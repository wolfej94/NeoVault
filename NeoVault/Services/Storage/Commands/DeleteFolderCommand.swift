//
//  DeleteFolderCommand.swift
//  NeoVault
//
//  Created by James Wolfe on 16/11/2024.
//

struct DeleteFolderCommand: AsyncCommand {

    let folderService: FolderService
    let folder: FolderViewModel

    func execute() async throws {
        try await folderService
            .delete(folder: folder)
    }
}
