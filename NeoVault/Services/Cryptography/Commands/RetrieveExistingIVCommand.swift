//
//  RetrieveExistingIVCommand.swift
//  NeoVault
//
//  Created by James Wolfe on 16/11/2024.
//

import Foundation

struct RetrieveExistingIVCommand: Command {

    func execute() throws -> Data {
        try KeychainHelper.retrieveKey(forKey: "aes_iv")
    }

}
