//
//  EncryptCommand.swift
//  NeoVault
//
//  Created by James Wolfe on 15/11/2024.
//

import Foundation

struct EncryptCommand: Command {

    let cryptographyService: CryptographyService
    let data: Data

    func execute() throws -> Data {
        try cryptographyService
            .encrypt(data)
    }
}
