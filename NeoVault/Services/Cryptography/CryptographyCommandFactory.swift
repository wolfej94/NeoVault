//
//  CryptographyCommandFactory.swift
//  NeoVault
//
//  Created by James Wolfe on 15/11/2024.
//

import Foundation

protocol CryptographyCommandFactory {
    func decryptCommand(data: Data) -> DecryptCommand
    func encryptCommand(data: Data) -> EncryptCommand
    func generateKeyCommand(salt: Data, password: String) -> GenerateKeyCommand
    func getSaltCommand() -> GetSaltCommand
    func storeSaltCommand(salt: Data, onProgress: ((Progress?) -> Void)?) -> StoreSaltCommand
    func retrieveExistingKeyCommand() -> RetrieveExistingKeyCommand
    func retrieveExistingIVCommand() -> RetrieveExistingIVCommand
}

struct DefaultCryptographyCommandFactory: CryptographyCommandFactory {

    let cryptographyService: CryptographyService
    let saltService: SaltService

    init(cryptographyService: CryptographyService = DefaultCryptographyService(),
         saltService: SaltService = DefaultSaltService()) {
        self.cryptographyService = cryptographyService
        self.saltService = saltService
    }

    func decryptCommand(data: Data) -> DecryptCommand {
        DecryptCommand(cryptographyService: cryptographyService, data: data)
    }

    func encryptCommand(data: Data) -> EncryptCommand {
        EncryptCommand(cryptographyService: cryptographyService, data: data)
    }

    func generateKeyCommand(salt: Data, password: String) -> GenerateKeyCommand {
        GenerateKeyCommand(cryptographyService: cryptographyService, password: password, salt: salt)
    }

    func storeSaltCommand(salt: Data, onProgress: ((Progress?) -> Void)?) -> StoreSaltCommand {
        StoreSaltCommand(saltService: saltService,
                         salt: salt,
                         onProgress: onProgress)
    }

    func getSaltCommand() -> GetSaltCommand {
        GetSaltCommand(saltService: saltService)
    }

    func retrieveExistingIVCommand() -> RetrieveExistingIVCommand {
        RetrieveExistingIVCommand()
    }

    func retrieveExistingKeyCommand() -> RetrieveExistingKeyCommand {
        RetrieveExistingKeyCommand()
    }

}
