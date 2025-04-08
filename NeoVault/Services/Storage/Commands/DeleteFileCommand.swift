//
//  DeleteFileCommand.swift
//  NeoVault
//
//  Created by James Wolfe on 16/11/2024.
//

struct DeleteFileCommand: AsyncCommand {

    let fileService: FileService
    let file: FileViewModel

    func execute() async throws {
        try await fileService.delete(file: file)
    }

}
