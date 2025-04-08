//
//  FolderView.swift
//  NeoVault
//
//  Created by James Wolfe on 15/11/2024.
//

import SwiftUI

enum FolderViewAction {
    typealias Handler = (Self) -> Void
    case select(folder: FolderViewModel)
    case delete(folder: FolderViewModel)
}

struct FolderView: View {

    private let folder: FolderViewModel
    private let actionHandler: FolderViewAction.Handler

    init(folder: FolderViewModel, actionHandler: @escaping FolderViewAction.Handler) {
        self.folder = folder
        self.actionHandler = actionHandler
    }

    var body: some View {
        Button(
            action: { actionHandler(.select(folder: folder)) },
            label: {
                HStack {
                    Image(uiImage: #imageLiteral(resourceName: "Folder"))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(Color.blueTwo)
                    Spacer()
                    VStack {
                        Text(folder.name)
                            .minimumScaleFactor(0.5)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .font(.body)
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        let metadata = [
                            String(format: "%d files", folder.contentCount),
                            String(format: "%.0fmb", folder.contentSize)
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
                .contextMenu {
                    Button("Delete", role: .destructive, action: { actionHandler(.delete(folder: folder)) })
                }
            }
        )
        .accessibilityLabel(folder.name)
    }

}
