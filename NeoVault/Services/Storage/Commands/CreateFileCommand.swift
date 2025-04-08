//
//  CreateFileCommand.swift
//  NeoVault
//
//  Created by James Wolfe on 16/11/2024.
//

import Foundation

struct CreateFileCommand: AsyncCommand {

    let fileService: FileService
    let name: String
    let folder: FolderViewModel
    let content: Data
    let contentType: String
    let onProgress: ((Progress?) -> Void)?

    func execute() async throws -> FileViewModel {
        try await fileService
            .create(
                fileNamed: name,
                inFolder: folder,
                contents: content,
                contentType: contentType,
                progress: onProgress
            )
    }
}
