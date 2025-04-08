//
//  AddMediaFileButton.swift
//  NeoVault
//
//  Created by James Wolfe on 16/11/2024.
//

import SwiftUI
import PhotosUI

struct AddMediaFileButton: View {

    private let proxy: GeometryProxy
    private let inputType: FileInputType
    private let visible: Bool
    var selectedMediaFile: Binding<PhotosPickerItem?>

    init(proxy: GeometryProxy,
         inputType: FileInputType,
         visible: Bool,
         selectedMediaFile: Binding<PhotosPickerItem?>) {
        self.proxy = proxy
        self.inputType = inputType
        self.visible = visible
        self.selectedMediaFile = selectedMediaFile
    }

    var body: some View {
        if let index = FileInputType.allCases.firstIndex(of: inputType) {
            PhotosPicker(
                selection: selectedMediaFile,
                matching: inputType == .image ? .images : .videos,
                label: {
                    Circle()
                        .foregroundStyle(.white)
                        .frame(height: 60)
                        .shadow(radius: visible ? 10 : .zero)
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
