//
//  FileView.swift
//  NeoVault
//
//  Created by James Wolfe on 16/11/2024.
//

import SwiftUI

enum FileViewAction {
    typealias Handler = (Self) -> Void
    case select(file: FileViewModel)
    case delete(file: FileViewModel)
}

struct FileView: View {

    private let actionHandler: FileViewAction.Handler
    private let file: FileViewModel

    init(actionHandler: @escaping FileViewAction.Handler, file: FileViewModel) {
        self.actionHandler = actionHandler
        self.file = file
    }

    var body: some View {
        Button(
            action: { actionHandler(.select(file: file)) },
            label: {
                HStack {
                    Image(mimeType: file.contentType)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(Color.blueTwo)
                    Spacer()
                    VStack {
                        Text(file.name)
                            .font(.body)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        let metadata = [
                            String(format: "%.0fmb", file.size)
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
                    Button("Delete", role: .destructive, action: { actionHandler(.delete(file: file)) })
                }
            }
        )
        .accessibilityLabel(file.name)
    }
}
