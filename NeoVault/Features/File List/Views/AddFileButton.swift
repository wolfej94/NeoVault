//
//  AddFileButton.swift
//  NeoVault
//
//  Created by James Wolfe on 16/11/2024.
//

import SwiftUI

enum AddFileButtonAction {
    typealias Handler = (Self) -> Void
    case addFile(withType: FileInputType)
}

struct AddFileButton: View {

    private let proxy: GeometryProxy
    private let inputType: FileInputType
    private let visible: Bool
    private let actionHandler: AddFileButtonAction.Handler

    init(proxy: GeometryProxy,
         inputType: FileInputType,
         visible: Bool,
         actionHandler: @escaping AddFileButtonAction.Handler) {
        self.proxy = proxy
        self.inputType = inputType
        self.visible = visible
        self.actionHandler = actionHandler
    }

    var body: some View {
        if let index = FileInputType.allCases.firstIndex(of: inputType) {
            Button(
                action: { actionHandler(.addFile(withType: inputType)) },
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
