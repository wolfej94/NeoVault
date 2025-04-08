//
//  StorageCommandFactory.swift
//  NeoVault
//
//  Created by James Wolfe on 16/11/2024.
//

import Foundation

protocol StorageCommandFactory {
    func createFileCommand(
        name: String,
        folder: FolderViewModel,
        content: Data,
        contentType: String,
        onProgress: ((Progress?) -> Void)?
    ) -> CreateFileCommand
    func createFolderCommand(name: String, onProgress: ((Progress?) -> Void)?) -> CreateFolderCommand
    func deleteFileCommand(file: FileViewModel) -> DeleteFileCommand
    func deleteFolderCommand(folder: FolderViewModel) -> DeleteFolderCommand
    func getFoldersCommand(synchronise: Bool) -> GetFoldersCommand
    func searchFilesCommand(query: String, fileType: FileType?) -> SearchFilesCommand
}

struct DefaultStorageCommandFactory: StorageCommandFactory {

    let storageService: FileService & FolderService

    init(storageService: FileService & FolderService = DefaultStorageService.shared) {
        self.storageService = storageService
    }

    func createFileCommand(
        name: String,
        folder: FolderViewModel,
        content: Data,
        contentType: String,
        onProgress: ((Progress?) -> Void)?
    ) -> CreateFileCommand {
        CreateFileCommand(
            fileService: storageService,
            name: name,
            folder: folder,
            content: content,
            contentType: contentType,
            onProgress: onProgress
        )
    }

    func createFolderCommand(name: String, onProgress: ((Progress?) -> Void)?) -> CreateFolderCommand {
        CreateFolderCommand(folderService: storageService, name: name, onProgress: onProgress)
    }

    func deleteFileCommand(file: FileViewModel) -> DeleteFileCommand {
        DeleteFileCommand(fileService: storageService, file: file)
    }

    func deleteFolderCommand(folder: FolderViewModel) -> DeleteFolderCommand {
        DeleteFolderCommand(folderService: storageService, folder: folder)
    }

    func getFoldersCommand(synchronise: Bool) -> GetFoldersCommand {
        GetFoldersCommand(folderService: storageService, synchronise: synchronise)
    }

    func searchFilesCommand(query: String, fileType: FileType?) -> SearchFilesCommand {
        SearchFilesCommand(fileService: storageService, query: query, fileType: fileType)
    }

}
