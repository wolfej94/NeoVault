//
//  FolderService.swift
//  NeoVault
//
//  Created by James Wolfe on 14/11/2024.
//

import Foundation

protocol FolderService {
    func fetchFolders(sync: Bool) async throws -> [FolderViewModel]
    func create(folderNamed name: String, progress: ((Progress?) -> Void)?) async throws -> FolderViewModel
    func delete(folder: FolderViewModel) async throws
}
