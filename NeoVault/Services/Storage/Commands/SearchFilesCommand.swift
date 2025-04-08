//
//  SearchFilesCommand.swift
//  NeoVault
//
//  Created by James Wolfe on 16/11/2024.
//

struct SearchFilesCommand: AsyncCommand {

    let fileService: FileService
    let query: String
    let fileType: FileType?

    func execute() async throws -> [FileViewModel] {
        try await fileService
            .search(
                query: query,
                fileType: fileType
            )
    }
}
