//
//  FileSearchViewModel.swift
//  NeoVault
//
//  Created by James Wolfe on 30/10/2024.
//

import SwiftUI
import Combine

enum FileSearchViewModelAction {
    typealias Handler = (Self) -> Void
    case cancelSearch
    case show(file: FilePreviewItem)
}

final class FileSearchViewModel: ViewModel, ObservableObject {

    private let storageCommandFactory: StorageCommandFactory
    private let cryptographyCommandFactory: CryptographyCommandFactory
    private let actionHandler: FileSearchViewModelAction.Handler
    private var cancellables = Set<AnyCancellable>()
    @Published var searchQuery = ""
    @Published var isEditing = false
    @Published private(set) var selectedFileType: FileType?
    @Published private(set) var files: [FileViewModel] = []

    var showPlaceholder: Bool {
        let isSearching = !searchQuery.isEmpty || selectedFileType != nil
        return files.isEmpty && isSearching && state == .loaded
    }

    init(actionHandler: @escaping FileSearchViewModelAction.Handler,
         cryptographyCommandFactory: CryptographyCommandFactory = DefaultCryptographyCommandFactory(),
         storageCommandFactory: StorageCommandFactory = DefaultStorageCommandFactory(),
         selectedFileType: FileType?) {
        self.actionHandler = actionHandler
        self.selectedFileType = selectedFileType
        self.storageCommandFactory = storageCommandFactory
        self.cryptographyCommandFactory = cryptographyCommandFactory
        super.init(state: .loaded)
        self.setupObservers()
    }

    private func setupObservers() {
        $searchQuery
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .sink { query in
                Task { [weak self] in
                    await self?.searchFiles(query: query, fileType: self?.selectedFileType)
                }
            }
            .store(in: &cancellables)

        $searchQuery
            .sink(receiveValue: { [weak self] _ in
                self?.setState(to: .loading)
            })
            .store(in: &cancellables)

        $selectedFileType
            .sink { selectedFileType in
                Task { [weak self] in
                    await self?.searchFiles(query: self?.searchQuery ?? "", fileType: selectedFileType)
                }
            }
            .store(in: &cancellables)
    }

}

// MARK: - UI Interactions
extension FileSearchViewModel {

    @MainActor
    private func searchFiles(query: String, fileType: FileType?) async {
        guard !query.isEmpty || fileType != nil else {
            files = []
            await setState(to: .loaded)
            return
        }
        do {
            files = try await storageCommandFactory
                .searchFilesCommand(query: query, fileType: fileType)
                .execute()
            await setState(to: .loaded)
        } catch {
            await setState(to: .error(message: error.localizedDescription))
        }
    }

    func cancelButtonTapped() {
        isEditing = false
        UIApplication.shared.endEditing()
        withAnimation {
            actionHandler(.cancelSearch)
        }
    }

    func fileTapped(file: FileViewModel) {
        guard let url = file.contents else { return }
        do {
            setState(to: .loading)
            let data = try cryptographyCommandFactory
                .decryptCommand(data: Data(contentsOf: url))
                .execute()
            let previewItem = FilePreviewItem(name: file.name, data: data, path: file.path)
            setState(to: .loaded)
            actionHandler(.show(file: previewItem))
        } catch {
            setState(to: .error(message: error.localizedDescription))
        }
    }

}

// MARK: - Action Handlers
extension FileSearchViewModel {

    func handleFileTypeViewAction(_ action: FileTypeViewAction) {
        switch action {
        case .select(let fileType):
            let isAlreadySelected = fileType == selectedFileType
            selectedFileType = isAlreadySelected ? nil : fileType
        }
    }

}
