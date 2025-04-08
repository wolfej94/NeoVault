//
//  FileTypeView.swift
//  NeoVault
//
//  Created by James Wolfe on 15/11/2024.
//

import SwiftUI

enum FileTypeViewAction {
    typealias Handler = (Self) -> Void
    case select(fileType: FileType)

}

struct FileTypeView: View {

    private let fileType: FileType
    private let actionHandler: FileTypeViewAction.Handler
    private let hasSelected: Bool
    private let isSelected: Bool

    init(fileType: FileType,
         selectedFileType: FileType?,
         actionHandler: @escaping FileTypeViewAction.Handler) {
        self.fileType = fileType
        self.actionHandler = actionHandler
        self.hasSelected = selectedFileType != nil
        self.isSelected = fileType == selectedFileType
    }

    init(fileType: FileType, actionHandler: @escaping FileTypeViewAction.Handler) {
        self.fileType = fileType
        self.actionHandler = actionHandler
        self.hasSelected = false
        self.isSelected = false
    }

    var body: some View {
        Button(
            action: { actionHandler(.select(fileType: fileType)) },
            label: {
                HStack {
                    fileType.image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.blueTwo)
                    Spacer()
                    Text(fileType.name)
                        .font(.body)
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color.blueFive)
                }
                .opacity(hasSelected && isSelected ? 0.5 : 1)
            }
        )
        .accessibilityLabel(fileType.name)
    }

}
