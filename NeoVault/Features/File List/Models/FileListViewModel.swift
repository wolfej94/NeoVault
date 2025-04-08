//
//  FileListViewModel.swift
//  NeoVault
//
//  Created by James Wolfe on 08/10/2024.
//

import SwiftUI
import Photos
import PhotosUI

enum FileListAction {
    typealias Handler = (Self) -> Void
    case show(file: FilePreviewItem)
    case dismiss
}

@Observable final class FileListViewModel: ViewModel {

    private let folder: FolderViewModel
    private let actionHandler: FileListAction.Handler
    private let storageCommandFactory: StorageCommandFactory
    private let cryptographyCommandFactory: CryptographyCommandFactory
    private(set) var files: [FileViewModel] = []
    var showAddFileOptions = false
    var selectedMediaFile: PhotosPickerItem?
    var filePickerTypes = [UTType]()
    var progress: Double?
    var showDocumentScanner = false

    var showPlaceholder: Bool {
        files.isEmpty && state != .loading
    }

    var navigationTitle: String {
        folder.name+"/"
    }

    init(folder: FolderViewModel,
         storageCommandFactory: StorageCommandFactory,
         cryptographyCommandFactory: CryptographyCommandFactory,
         actionHandler: @escaping FileListAction.Handler) {
        self.folder = folder
        self.storageCommandFactory = storageCommandFactory
        self.actionHandler = actionHandler
        self.files = folder.files
        self.cryptographyCommandFactory = cryptographyCommandFactory
        super.init(state: .loaded)
    }

}

// MARK: - Upload Handlers
extension FileListViewModel {

    @MainActor
    private func uploadSelected(result: Result<UploadData, Error>) async {
        withAnimation {
            showAddFileOptions = false
        }
        do {
            switch result {
            case .success(let upload):
                await setState(to: .loading)
                let encryptedData = try cryptographyCommandFactory
                    .encryptCommand(data: upload.data)
                    .execute()
                let file = try await storageCommandFactory
                    .createFileCommand(
                        name: upload.name,
                        folder: folder,
                        content: encryptedData,
                        contentType: upload.mimeType,
                        onProgress: onProgress(_:)
                    )
                    .execute()
                files.append(file)
                withAnimation {
                    progress = nil
                }
                await setState(to: .loaded)
            case .failure(let error):
                throw error
            }
        } catch {
            await setState(to: .error(message: error.localizedDescription))
        }
    }

    private func onProgress(_ progress: Progress?) {
        guard let progress = progress else { return }
        withAnimation {
            self.progress = progress.fractionCompleted
        }
    }

}

// MARK: - UI Interactions
extension FileListViewModel {

    func addFileButtonTapped() {
        withAnimation {
            showAddFileOptions.toggle()
        }
    }

    func dismissButtonTapped() {
        actionHandler(.dismiss)
    }

    func mediaFileSelected(_ file: PhotosPickerItem) {
        selectedMediaFile = nil
        Task { [weak self] in
            do {
                let name = file.itemIdentifier ?? file.generateName()
                guard let data = try await file.loadTransferable(type: Data.self),
                      let fileExtension = file.supportedContentTypes.first?.preferredFilenameExtension,
                      let mimeType = file.mimeType else {
                    await self?.setState(to: .error(message: "Failed to load photo data"))
                    return
                }
                let upload = UploadData(
                    name: [name, fileExtension].joined(separator: "."),
                    data: data,
                    mimeType: mimeType
                )
                await self?.uploadSelected(result: .success(upload))
            } catch {
                await self?.uploadSelected(result: .failure(error))
            }
        }
    }

    func fileSelected(result: Result<URL, Error>) {
        filePickerTypes = []
        showDocumentScanner = false
        do {
            switch result {
            case .success(let url):
                guard let mimeType = UTType(filenameExtension: url.pathExtension)?.preferredMIMEType else {
                    setState(to: .error(message: "Failed to load file data"))
                    return
                }

                let name = url.lastPathComponent
                _ = url.startAccessingSecurityScopedResource()
                let data = try Data(contentsOf: url)
                url.stopAccessingSecurityScopedResource()
                let upload = UploadData(
                    name: name,
                    data: data,
                    mimeType: mimeType
                )
                Task { [weak self] in
                    await self?.uploadSelected(result: .success(upload))
                }
            case .failure(let error):
                throw error
            }
        } catch {
            Task { [weak self] in
                await self?.uploadSelected(result: .failure(error))
            }
        }
    }

}

// MARK: - File Actions
private extension FileListViewModel {

    func select(file: FileViewModel) {
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

    @MainActor
    func delete(file: FileViewModel) async {
        do {
            try await storageCommandFactory
                .deleteFileCommand(file: file)
                .execute()
            withAnimation {
                files.removeAll(where: { $0 == file })
            }
        } catch {
            await setState(to: .error(message: error.localizedDescription))
        }
    }

}

// MARK: - Action Handlers
extension FileListViewModel {

    func handleFileViewAction(_ action: FileViewAction) {
        switch action {
        case .select(let file):
            select(file: file)
        case .delete(let file):
            Task {
                await delete(file: file)
            }
        }
    }

    func handleAddFileButtonAction(_ action: AddFileButtonAction) {
        switch action {
        case .addFile(let type):
            filePickerTypes = type.utTypes
        }
    }

    func handleAddScannedDocumentButtonAction(_ action: AddScannedDocumentFileButtonAction) {
        switch action {
        case .showDocumentScanner:
            showDocumentScanner = true
        }
    }

}
