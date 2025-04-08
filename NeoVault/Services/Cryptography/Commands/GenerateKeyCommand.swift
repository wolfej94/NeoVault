//
//  GenerateKeyCommand.swift
//  NeoVault
//
//  Created by James Wolfe on 15/11/2024.
//

import Foundation

struct GenerateKeyCommand: Command {

    let cryptographyService: CryptographyService
    let password: String
    let salt: Data

    func execute() throws {
        try cryptographyService
            .syncKey(withPassword: password, salt: salt)
    }
}
