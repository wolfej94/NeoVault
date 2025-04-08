//
//  FileSearchCoordinator.swift
//  NeoVault
//
//  Created by James Wolfe on 30/10/2024.
//

import SwiftUI

enum FileSearchCoordinatorAction {
    typealias Handler = (Self) -> Void
    case dismiss
    case show(file: FilePreviewItem)
}

struct FileSearchCoordinator: View {

    private let actionHandler: FileSearchCoordinatorAction.Handler
    private let cryptographyCommandFactory: CryptographyCommandFactory
    private let storageCommandFactory: StorageCommandFactory
    private let matchedGeometryNamespace: Namespace.ID
    @State private var selectedFileType: FileType?

    init(actionHandler: @escaping FileSearchCoordinatorAction.Handler,
         selectedFileType: FileType?,
         matchedGeometryNamespace: Namespace.ID,
         cryptographyCommandFactory: CryptographyCommandFactory = DefaultCryptographyCommandFactory(),
         storageCommandFactory: StorageCommandFactory = DefaultStorageCommandFactory()) {
        self.actionHandler = actionHandler
        self.matchedGeometryNamespace = matchedGeometryNamespace
        self.storageCommandFactory = storageCommandFactory
        self.cryptographyCommandFactory = cryptographyCommandFactory
        _selectedFileType = .init(initialValue: selectedFileType)
    }

    var body: some View {
        let viewModel = FileSearchViewModel(
            actionHandler: handleFileSearchAction,
            cryptographyCommandFactory: cryptographyCommandFactory,
            storageCommandFactory: storageCommandFactory,
            selectedFileType: selectedFileType
        )

        FileSearchView(viewModel: viewModel, matchedGeometryNamespace: matchedGeometryNamespace)
    }

}

// MARK: - Action Handlers
extension FileSearchCoordinator {

    private func handleFileSearchAction(_ action: FileSearchViewModelAction) {
        switch action {
        case .cancelSearch:
            selectedFileType = nil
            actionHandler(.dismiss)
        case .show(let file):
            actionHandler(.show(file: file))
        }
    }

}
