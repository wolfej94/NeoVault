//
//  AddScannedDocumentFileButton.swift
//  NeoVault
//
//  Created by James Wolfe on 16/11/2024.
//

import SwiftUI

enum AddScannedDocumentFileButtonAction {
    typealias Handler = (Self) -> Void
    case showDocumentScanner
}

struct AddScannedDocumentFileButton: View {

    private let proxy: GeometryProxy
    private let inputType: FileInputType = .scannedDocument
    private let visible: Bool
    private let actionHandler: AddScannedDocumentFileButtonAction.Handler

    init(proxy: GeometryProxy,
         visible: Bool,
         actionHandler: @escaping AddScannedDocumentFileButtonAction.Handler) {
        self.proxy = proxy
        self.visible = visible
        self.actionHandler = actionHandler
    }

    var body: some View {
        if let index = FileInputType.allCases.firstIndex(of: inputType) {
            Button(
                action: { actionHandler(.showDocumentScanner) },
                label: {
                    Circle()
                        .foregroundStyle(.white)
                        .frame(height: 60)
                        .shadow(radius: 10)
                        .overlay {
                            inputType.image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 20)
                                .foregroundStyle(Color.blueTwo)
                        }
                }
            )
            .offset(x: proxy.size.width / 2 - 55)
            .offset(y: proxy.size.height / 2 - 55)
            .offset(y: visible ? -80 * CGFloat(index + 1) : .zero)
        } else {
            EmptyView()
        }
    }

}
