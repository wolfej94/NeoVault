//
//  FileListView.swift
//  NeoVault
//
//  Created by James Wolfe on 08/10/2024.
//

import SwiftUI

struct FileListView: View {

    @State private var viewModel: FileListViewModel

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    init(viewModel: FileListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        if case .loading = viewModel.state {
            VStack {
                if let progress = viewModel.progress {
                    ProgressView(value: progress)
                        .progressViewStyle(.linear)
                        .tint(Color.blueTwo)
                } else {
                    ProgressView()
                }
            }
            .padding()
            .navigationBarHidden(true)
        } else {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    headerSection
                        .padding(.horizontal)
                    VStack {
                        Text(viewModel.navigationTitle)
                            .foregroundStyle(.text)
                            .font(.system(size: 28, weight: .thin))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        if case .error(let message) = viewModel.state {
                            Text(message)
                                .foregroundStyle(Color.red)
                                .font(.caption)
                        } else {
                            if viewModel.showPlaceholder {
                                Text("No files yet")
                                    .font(.caption)
                            } else {
                                LazyVGrid(columns: columns, spacing: 10) {
                                    ForEach(viewModel.files, id: \.name) { file in
                                        FileView(actionHandler: viewModel.handleFileViewAction(_:), file: file)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 100)
                }
            }
            .blur(radius: viewModel.showAddFileOptions ? 10 : .zero)
            .overlay {
                addFileMenu
            }
            .background {
                Color.background
                    .ignoresSafeArea()
            }
            .onReceive(viewModel.selectedMediaFile.publisher, perform: { mediaFile in
                viewModel.mediaFileSelected(mediaFile)
            })
            .navigationBarHidden(true)
        }
    }

    var addFileMenu: some View {
        GeometryReader { proxy in
            VStack(alignment: .trailing, spacing: 10) {
                Spacer()
                Button(
                    action: viewModel.addFileButtonTapped,
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
                            .rotationEffect(Angle(degrees: viewModel.showAddFileOptions ? 315 : .zero))
                    }
                )
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .background {
                ZStack {
                    ForEach(FileInputType.allCases, id: \.self) { inputType in
                        switch inputType {
                        case .audio, .document:
                            AddFileButton(
                                proxy: proxy,
                                inputType: inputType,
                                visible: viewModel.showAddFileOptions,
                                actionHandler: viewModel.handleAddFileButtonAction(_:)
                            )
                        case .scannedDocument:
                            AddScannedDocumentFileButton(
                                proxy: proxy,
                                visible: viewModel.showAddFileOptions,
                                actionHandler: viewModel.handleAddScannedDocumentButtonAction(_:)
                            )
                        case .image, .video:
                            AddMediaFileButton(
                                proxy: proxy,
                                inputType: inputType,
                                visible: viewModel.showAddFileOptions,
                                selectedMediaFile: $viewModel.selectedMediaFile
                            )
                        }
                    }
                }
            }
            .padding()
            .background(Color.black.opacity(viewModel.showAddFileOptions ? 0.7 : .zero))
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
        .fileImporter(
            isPresented: .init(
                get: { !viewModel.filePickerTypes.isEmpty },
                set: { viewModel.filePickerTypes = $0 ? viewModel.filePickerTypes : [] }
            ), allowedContentTypes: viewModel.filePickerTypes,
            onCompletion: viewModel.fileSelected(result:)
        )
        .sheet(isPresented: $viewModel.showDocumentScanner) {
            DocumentScannerView(
                pdfURL: .init(
                    get: { nil },
                    set: {
                        guard let url = $0 else { return }
                        viewModel.fileSelected(result: .success(url))
                    }
                )
            )
        }
    }

    var headerSection: some View {
        HStack {
            Button(
                action: viewModel.dismissButtonTapped,
                label: {
                    Image(uiImage: #imageLiteral(resourceName: "Back"))
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.blueThree)
                        .frame(width: 40, height: 40)
                }
            )
            Spacer()
        }
    }

}
