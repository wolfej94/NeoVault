//
//  StoreSaltCommand.swift
//  NeoVault
//
//  Created by James Wolfe on 15/11/2024.
//

import Foundation

struct StoreSaltCommand: AsyncCommand {

    let saltService: SaltService
    let salt: Data
    let onProgress: ((Progress?) -> Void)?

    func execute() async throws {
        try await saltService.storeSalt(data: salt, onProgress: onProgress)
    }

}
