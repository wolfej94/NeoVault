//
//  FileService.swift
//  NeoVault
//
//  Created by James Wolfe on 14/11/2024.
//

import Foundation

protocol FileService {
    func create(
        fileNamed name: String,
        inFolder folder: FolderViewModel,
        contents: Data,
        contentType: String,
        progress: ((Progress?) -> Void)?) async throws -> FileViewModel
    func delete(file: FileViewModel) async throws
    func search(query: String, fileType: FileType?) async throws -> [FileViewModel]
}
