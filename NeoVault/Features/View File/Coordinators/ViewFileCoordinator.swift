//
//  ViewFileCoordinator.swift
//  NeoVault
//
//  Created by James Wolfe on 13/11/2024.
//

import SwiftUI

enum ViewFileCoordinatorAction {
    typealias Handler = (Self) -> Void
    case dismiss
}

struct ViewFileCoordinator: View {

    private let file: FilePreviewItem
    private let actionHandler: ViewFileCoordinatorAction.Handler
    @State private var shareURL: URL?

    init(file: FilePreviewItem,
         actionHandler: @escaping ViewFileCoordinatorAction.Handler,
         shareURL: URL? = nil) {
        self.file = file
        self.actionHandler = actionHandler
        self.shareURL = shareURL
    }

    var body: some View {
        let viewModel = ViewFileViewModel(file: file, actionHandler: handleViewFileViewModelAction(_:))
        ViewFileView(viewModel: viewModel)
            .sheet(item: $shareURL) { url in
                ShareSheet(items: [url])
            }
    }

}

// MARK: - Action Handlers
extension ViewFileCoordinator {

    private func handleViewFileViewModelAction(_ action: ViewFileViewModelAction) {
        switch action {
        case .dismiss:
            actionHandler(.dismiss)
        case .share(let url):
            shareURL = url
        }
    }

}
