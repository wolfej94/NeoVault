//
//  GetFoldersCommand.swift
//  NeoVault
//
//  Created by James Wolfe on 16/11/2024.
//

struct GetFoldersCommand: AsyncCommand {

    let folderService: FolderService
    let synchronise: Bool

    func execute() async throws -> [FolderViewModel] {
        try await folderService
            .fetchFolders(sync: synchronise)
    }
}
