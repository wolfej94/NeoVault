//
//  CreateFolderCommand.swift
//  NeoVault
//
//  Created by James Wolfe on 16/11/2024.
//

import Foundation

struct CreateFolderCommand: AsyncCommand {

    let folderService: FolderService
    let name: String
    let onProgress: ((Progress?) -> Void)?

    func execute() async throws -> FolderViewModel {
        try await folderService
            .create(
                folderNamed: name,
                progress: onProgress
            )
    }
}
