//
//  FolderListView.swift
//  NeoVault
//
//  Created by James Wolfe on 08/10/2024.
//

import SwiftUI

struct FolderListView: View {

    @State private var viewModel: FolderListViewModel
    private let matchedGeometryNamespace: Namespace.ID

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    init(viewModel: FolderListViewModel, matchedGeometryNamespace: Namespace.ID) {
        self.viewModel = viewModel
        self.matchedGeometryNamespace = matchedGeometryNamespace
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 30) {
                headerSection
                    .padding(.horizontal)
                UsageSummaryView(usage: .init(
                    documentUsage: viewModel.folders
                        .reduce(into: .zero, { $0 += CGFloat($1.fileTypeSizes[.document] ?? .zero) }),
                    imageUsage: viewModel.folders
                        .reduce(into: .zero, { $0 += CGFloat($1.fileTypeSizes[.image] ?? .zero) }),
                    videoUsage: viewModel.folders
                        .reduce(into: .zero, { $0 += CGFloat($1.fileTypeSizes[.video] ?? .zero) }),
                    musicUsage: viewModel.folders
                        .reduce(into: .zero, { $0 += CGFloat($1.fileTypeSizes[.audio] ?? .zero) }),
                    maxUsage: 2000)
                )
                .padding(.horizontal)
                searchSection
                VStack {
                    Text("folders")
                        .foregroundStyle(.text)
                        .font(.system(size: 28, weight: .thin))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if viewModel.showPlaceholder && !viewModel.showNewFolder {
                        Text("No folders yet")
                            .font(.caption)
                    } else {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(viewModel.folders, id: \.name) { folder in
                                FolderView(folder: folder, actionHandler: viewModel.handleFolderViewAction(_:))
                                    .matchedGeometryEffect(id: folder.name, in: matchedGeometryNamespace)
                            }
                            if viewModel.showNewFolder {
                                NewFolderView(
                                    editing: viewModel.newFolderEditing,
                                    name: $viewModel.newFolderName,
                                    actionHandler: viewModel.handleNewFolderViewAction(_:)
                                )
                                .matchedGeometryEffect(
                                    id: viewModel.newFolderNameAlreadyExists ? "" : viewModel.newFolderName,
                                    in: matchedGeometryNamespace
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 100)
            }
        }
        .refreshable(action: { await viewModel.refresh(true) })
        .overlay {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(
                        action: viewModel.addFolderButtonTapped,
                        label: {
                            Image(uiImage: #imageLiteral(resourceName: "AddCircle"))
                                .resizable()
                                .scaledToFit()
                                .frame(height: 80)
                                .foregroundStyle(Color.blueTwo)
                                .background {
                                    Circle().foregroundStyle(.white)
                                        .padding(10)
                                        .shadow(radius: 10)
                                }
                        }
                    )
                }
            }
            .padding()
            .ignoresSafeArea()
        }
        .background {
            Color.background
                .ignoresSafeArea()
        }
        .navigationBarHidden(true)
    }

    var searchSection: some View {
        VStack(spacing: 20) {
            searchButton
                .zIndex(2)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(FileType.allCases, id: \.self) { fileType in
                        FileTypeView(fileType: fileType, actionHandler: viewModel.handleFileTypeViewAction(_:))
                    }
                }
                .padding(.horizontal)
            }
            .matchedGeometryEffect(id: "file_types", in: matchedGeometryNamespace)
        }
    }

    var searchButton: some View {
        Button(
            action: viewModel.searchTapped,
            label: {
                Text("Search file...")
                    .foregroundStyle(Color.text.opacity(0.5))
                    .frame(maxWidth: .infinity,
                           minHeight: 60,
                           alignment: .leading
                    )
                    .padding(.leading, 15)
                    .padding(.trailing, 60)
                    .background(Color.field)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.text.opacity(0.5), lineWidth: 1)
                    }
                    .overlay {
                        HStack {
                            Spacer()
                            Image(uiImage: #imageLiteral(resourceName: "Search"))
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.blueOne)
                                .frame(width: 30)
                        }
                        .padding(.trailing, 15)
                    }
                    .padding(.all, 1)
                    .padding(.horizontal)
                    .matchedGeometryEffect(id: "search_field", in: matchedGeometryNamespace)
            }
        )
    }

    var headerSection: some View {
        HStack {
            Text(viewModel.greetingText)
            Spacer()
            Button(
                action: viewModel.profileButtonTapped,
                label: {
                    Image(uiImage: #imageLiteral(resourceName: "PersonCircle"))
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .foregroundStyle(Color.blueTwo)
                }
            )
        }
    }

}
