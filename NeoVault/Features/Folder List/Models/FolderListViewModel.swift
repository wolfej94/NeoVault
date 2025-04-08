//
//  FolderListViewModel.swift
//  NeoVault
//
//  Created by James Wolfe on 08/10/2024.
//

import SwiftUI

enum FolderListViewModelAction {
    typealias Handler = (Self) -> Void
    case show(folder: FolderViewModel)
    case select(fileType: FileType)
    case showProfile
    case showSearch
}

@Observable final class FolderListViewModel: ViewModel {

    private let authenticationCommandFactory: AuthenticationCommandFactory
    private let storageCommandFactory: StorageCommandFactory
    private let actionHandler: FolderListViewModelAction.Handler
    private var newFolderPending = false
    var newFolderEditing = true
    var newFolderName = ""
    var showNewFolder = false
    var folders: [FolderViewModel] = []

    var newFolderNameAlreadyExists: Bool {
        folders.contains { $0.name == newFolderName }
    }

    var greetingText: String {
        let localizedString = String(localized: "Hello %@")
        let userName = try? authenticationCommandFactory
            .userNameCommand()
            .execute()
        return String(format: localizedString, userName ?? "")
    }

    var showPlaceholder: Bool {
        folders.isEmpty && state != .loading
    }

    init(authenticationCommandFactory: AuthenticationCommandFactory,
         storageCommandFactory: StorageCommandFactory,
         actionHandler: @escaping FolderListViewModelAction.Handler) {
        self.authenticationCommandFactory = authenticationCommandFactory
        self.storageCommandFactory = storageCommandFactory
        self.actionHandler = actionHandler
        super.init(state: .loading)
        Task { await refresh(false) }
        setupObservers()
    }

}

// MARK: - Setup
extension FolderListViewModel {

    private func setupObservers() {
        NotificationCenter.default.addObserver(forName: .foldersUpdated, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            withAnimation {
                if self.newFolderPending {
                    self.showNewFolder = false
                    self.newFolderName = ""
                    self.newFolderEditing = true
                }
            }
            Task { await self.refresh(false) }
            self.newFolderPending = false
        }
    }

}

// MARK: - Action Handlers
extension FolderListViewModel {

    func handleFolderViewAction(_ action: FolderViewAction) {
        switch action {
        case .delete(let folder):
            Task { await delete(folder: folder) }
        case .select(let folder):
            select(folder: folder)
        }
    }

    func handleNewFolderViewAction(_ action: NewFolderAction) {
        switch action {
        case .create:
            Task { await createFolder() }
        }
    }

    func handleFileTypeViewAction(_ action: FileTypeViewAction) {
        switch action {
        case .select(let fileType):
            select(fileType: fileType)
        }
    }

}

// MARK: - Folder Interactions
private extension FolderListViewModel {
    func select(folder: FolderViewModel) {
        withAnimation {
            actionHandler(.show(folder: folder))
        }
    }

    @MainActor
    func delete(folder: FolderViewModel) async {
        do {
            try await storageCommandFactory
                .deleteFolderCommand(folder: folder)
                .execute()
        } catch {
            await setState(to: .error(message: error.localizedDescription))
        }
    }

    @MainActor
    func createFolder() async {
        newFolderEditing = false
        UIApplication.shared.endEditing()
        guard newFolderName.isEmpty == false else {
            withAnimation {
                showNewFolder = false
                newFolderName = ""
            } completion: { [weak self] in
                self?.newFolderEditing = true
            }
            return
        }
        do {
            await setState(to: .loading)
            newFolderPending = true
            _ = try await storageCommandFactory
                .createFolderCommand(name: newFolderName, onProgress: nil)
                .execute()
            await setState(to: .loaded)
        } catch {
            await setState(to: .error(message: error.localizedDescription))
        }
    }
}

// MARK: File Type Interactions
extension FolderListViewModel {

    func select(fileType: FileType) {
        withAnimation {
            actionHandler(.select(fileType: fileType))
        }
    }

}

// MARK: - UI Actions
extension FolderListViewModel {
    func addFolderButtonTapped() {
        withAnimation {
            showNewFolder = true
        }
    }

    @MainActor func refresh(_ sync: Bool) async {
        do {
            await setState(to: .loading)
            let folders = try await storageCommandFactory
                .getFoldersCommand(synchronise: sync)
                .execute()
            withAnimation {
                self.folders = folders
            }
            await setState(to: .loaded)
        } catch {
            await setState(to: .error(message: error.localizedDescription))
        }
    }

    func profileButtonTapped() {
        actionHandler(.showProfile)
    }

    func searchTapped() {
        withAnimation {
            actionHandler(.showSearch)
        }
    }

}
