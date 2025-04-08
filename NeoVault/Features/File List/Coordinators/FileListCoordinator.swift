//
//  FileListCoordinator.swift
//  NeoVault
//
//  Created by James Wolfe on 08/10/2024.
//

import SwiftUI

enum FileListCoordinatorAction {
    typealias Handler = (Self) -> Void
    case dismiss
}

struct FileListCoordinator: View {

    private let actionHandler: FileListCoordinatorAction.Handler
    private let storageCommandFactory: StorageCommandFactory
    private let cryptographyCommandFactory: CryptographyCommandFactory
    let folder: FolderViewModel
    @State var selectedFile: FilePreviewItem?
    @State var shareURL: URL?
    @State var showDocumentScanner = false

    init(actionHandler: @escaping FileListCoordinatorAction.Handler,
         cryptographyCommandFactory: CryptographyCommandFactory = DefaultCryptographyCommandFactory(),
         storageCommandFactory: StorageCommandFactory = DefaultStorageCommandFactory(),
         folder: FolderViewModel) {
        self.actionHandler = actionHandler
        self.storageCommandFactory = storageCommandFactory
        self.cryptographyCommandFactory = cryptographyCommandFactory
        self.folder = folder
    }

    var body: some View {
        let viewModel = FileListViewModel(
            folder: folder,
            storageCommandFactory: storageCommandFactory,
            cryptographyCommandFactory: cryptographyCommandFactory,
            actionHandler: handleFileListAction(_:)
        )
        FileListView(viewModel: viewModel)
            .navigationDestination(item: $selectedFile, destination: { file in
                ViewFileCoordinator(file: file, actionHandler: handleViewFileCoordinatorAction(_:))
            })
            .sheet(item: $shareURL) { url in
                ShareSheet(items: [url])
            }
    }

}

// MARK: - Action Handlers
extension FileListCoordinator {

    private func handleViewFileCoordinatorAction(_ action: ViewFileCoordinatorAction) {
        switch action {
        case .dismiss:
            selectedFile = nil
        }
    }

    private func handleFileListAction(_ action: FileListAction) {
        switch action {
        case .show(let file):
            selectedFile = file
        case .dismiss:
            actionHandler(.dismiss)
        }
    }

}
