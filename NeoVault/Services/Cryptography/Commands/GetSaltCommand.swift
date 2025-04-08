//
//  FetchSaltCommand.swift
//  NeoVault
//
//  Created by James Wolfe on 15/11/2024.
//

import Foundation

struct GetSaltCommand: AsyncCommand {

    let saltService: SaltService

    func execute() async throws -> Data {
        try await saltService.salt()
    }

}
