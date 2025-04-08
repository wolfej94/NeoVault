//
//  FolderCoordinator.swift
//  NeoVault
//
//  Created by James Wolfe on 08/10/2024.
//

import SwiftUI

struct FolderListCoordinator: View {

    private let authenticationCommandFactory: AuthenticationCommandFactory
    private let storageCommandFactory: StorageCommandFactory
    @State private var selectedFolder: FolderViewModel?
    @State private var showProfile = false
    @State private var showSearch = false
    @State private var selectedFileType: FileType?
    @State private var selectedFile: FilePreviewItem?
    @Namespace private var matchedGeometryNamespace
    @State private var shareURL: URL?

    init(selectedFolder: FolderViewModel? = nil,
         authenticationCommandFactory: AuthenticationCommandFactory = DefaultAuthenticationCommandFactory(),
         storageCommandFactory: StorageCommandFactory = DefaultStorageCommandFactory()) {
        self.selectedFolder = selectedFolder
        self.authenticationCommandFactory = authenticationCommandFactory
        self.storageCommandFactory = storageCommandFactory
    }

    var body: some View {
        let viewModel = FolderListViewModel(
            authenticationCommandFactory: authenticationCommandFactory,
            storageCommandFactory: storageCommandFactory,
            actionHandler: handleFolderListAction(_:)
        )
        VStack {
            switch showSearch {
            case true:
                FileSearchCoordinator(actionHandler: handleFileSearchAction(_:),
                                      selectedFileType: selectedFileType,
                                      matchedGeometryNamespace: matchedGeometryNamespace)
            case false:
                FolderListView(
                    viewModel: viewModel,
                    matchedGeometryNamespace: matchedGeometryNamespace
                )
            }
        }
        .navigationDestination(item: $selectedFolder) { folder in
            FileListCoordinator(
                actionHandler: handleFileListAction(_:),
                folder: folder
            )
        }
        .navigationDestination(isPresented: $showProfile, destination: {
            ProfileCoordinator(actionHandler: handleProfileAction(_:))
        })
        .navigationDestination(item: $selectedFile, destination: { file in
            ViewFileCoordinator(file: file, actionHandler: handleViewFileCoordinatorAction(_:))
        })
    }

}

// MARK: - Action Handlers
extension FolderListCoordinator {

    private func handleViewFileCoordinatorAction(_ action: ViewFileCoordinatorAction) {
        switch action {
        case .dismiss:
            selectedFile = nil
        }
    }

    private func handleFileSearchAction(_ action: FileSearchCoordinatorAction) {
        switch action {
        case .dismiss:
            showSearch = false
        case .show(let file):
            selectedFile = file
        }
    }

    private func handleFileListAction(_ action: FileListCoordinatorAction) {
        switch action {
        case .dismiss:
            selectedFolder = nil
        }
    }

    private func handleProfileAction(_ action: ProfileCoordinatorAction) {
        switch action {
        case .dismiss:
            showProfile = false
        }
    }

    private func handleFolderListAction(_ action: FolderListViewModelAction) {
        switch action {
        case .show(let folder):
            selectedFolder = folder
        case .select(let fileType):
            selectedFileType = fileType
            showSearch = true
        case .showProfile:
            showProfile = true
        case .showSearch:
            selectedFileType = nil
            showSearch = true
        }
    }

}
