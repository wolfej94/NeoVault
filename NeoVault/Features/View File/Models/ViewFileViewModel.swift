//
//  ViewFileViewModel.swift
//  NeoVault
//
//  Created by James Wolfe on 13/11/2024.
//

import SwiftUI

enum ViewFileViewModelAction {
    typealias Handler = (Self) -> Void
    case share(url: URL)
    case dismiss
}

@Observable final class ViewFileViewModel: ViewModel {

    let file: FilePreviewItem
    let actionHandler: ViewFileViewModelAction.Handler

    init(file: FilePreviewItem,
         actionHandler: @escaping ViewFileViewModelAction.Handler) {
        self.file = file
        self.actionHandler = actionHandler
    }

}

// MARK: - UI Actions
extension ViewFileViewModel {

    func shareButtonTapped() {
        guard let url = file.url else { return }
        actionHandler(.share(url: url))
    }

    func dismissButtonTapped() {
        actionHandler(.dismiss)
    }

}
