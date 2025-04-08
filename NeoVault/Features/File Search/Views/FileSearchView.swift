//
//  FileSearchView.swift
//  NeoVault
//
//  Created by James Wolfe on 30/10/2024.
//

import SwiftUI

struct FileSearchView: View {

    @ObservedObject private var viewModel: FileSearchViewModel
    private var matchedGeometryNamespace: Namespace.ID

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    init(viewModel: FileSearchViewModel, matchedGeometryNamespace: Namespace.ID) {
        self.viewModel = viewModel
        self.matchedGeometryNamespace = matchedGeometryNamespace
    }

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: .zero) {
                VaultTextField(
                    image: #imageLiteral(resourceName: "Search"),
                    placeholder: "Search file...",
                    disabled: false,
                    keyboardType: .default,
                    isEditing: viewModel.isEditing,
                    text: $viewModel.searchQuery
                )
                .frame(height: 60)
                .padding(.horizontal)
                .matchedGeometryEffect(id: "search_field", in: matchedGeometryNamespace)
                Button(
                    action: viewModel.cancelButtonTapped,
                    label: {
                        Text("Cancel")
                            .foregroundStyle(Color.blueTwo)
                    }
                )
                .padding(.trailing, 20)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(FileType.allCases, id: \.self) { fileType in
                        FileTypeView(
                            fileType: fileType,
                            selectedFileType: viewModel.selectedFileType,
                            actionHandler: viewModel.handleFileTypeViewAction(_:)
                        )
                    }
                }
                .padding(.horizontal)
            }
            .matchedGeometryEffect(id: "file_types", in: matchedGeometryNamespace)
            ScrollView {
                switch viewModel.state {
                case .loaded:
                    fileListView
                case .loading:
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                case .error(let message):
                    Text(message)
                        .font(.caption)
                        .foregroundStyle(Color.red)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .onAppear {
            viewModel.isEditing = true
        }
    }

    var fileListView: some View {
        VStack {
            if viewModel.showPlaceholder {
                Text("No results for \"\(viewModel.searchQuery)\"")
                    .font(.caption)
            } else {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.files, id: \.name) { file in
                        Button(
                            action: {
                                viewModel.fileTapped(file: file)
                            },
                            label: {
                                VStack {
                                    Image(mimeType: file.contentType)
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(Color.text)
                                        .frame(width: 50, height: 50)
                                        .padding()

                                    Text(file.name)
                                        .foregroundStyle(Color.text)
                                        .font(.caption)
                                }
                            }
                        )
                        .accessibilityLabel(file.name)
                    }
                }
            }
        }
        .padding()
    }

}
