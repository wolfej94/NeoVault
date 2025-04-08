//
//  NewFolderView.swift
//  NeoVault
//
//  Created by James Wolfe on 15/11/2024.
//

import SwiftUI

enum NewFolderAction {
    typealias Handler = (Self) -> Void
    case create
}

struct NewFolderView: View {

    private let editing: Bool
    @State private var name: Binding<String>
    private let actionHandler: NewFolderAction.Handler

    init(editing: Bool, name: Binding<String>, actionHandler: @escaping NewFolderAction.Handler) {
        self.editing = editing
        self.name = name
        self.actionHandler = actionHandler
    }

    var body: some View {
        HStack {
            Image(uiImage: #imageLiteral(resourceName: "Folder"))
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundStyle(Color.blueTwo)
            Spacer()
            VStack {
                VaultTextField(
                    placeholder: "",
                    disabled: false,
                    autoCapitalisation: .words,
                    keyboardType: .default,
                    isEditing: editing,
                    text: name,
                    returnButtonType: .done,
                    returnButtonAction: { actionHandler(.create) }
                )
                .frame(height: 30)
                let metadata = [
                    String(format: "0 files"),
                    String(format: "0mb")
                ]
                Text(metadata.joined(separator: " | "))
                    .font(.caption)
                    .foregroundStyle(Color.white.opacity(0.7))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color.blueFive)
        }
    }

}
