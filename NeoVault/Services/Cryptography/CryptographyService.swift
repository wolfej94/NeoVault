//
//  EncryptionService.swift
//  NeoVault
//
//  Created by James Wolfe on 07/10/2024.
//

import Foundation
import UIKit
import CommonCrypto

enum CryptographyError: Error {
    case encryptionFailed
    case decryptionFailed
    case invalidImageData
    case invalidTextData
    case keyGenerationFailed
    case keychainError
    case invalidKeyLength
    case keyDerivationFailed
}

protocol CryptographyService {
    func encrypt(_ data: Data) throws -> Data
    func decrypt(_ data: Data) throws -> Data
    func syncKey(withPassword password: String, salt: Data) throws
    func clearKey() throws
}

final class DefaultCryptographyService: CryptographyService {

    private var derivedKey: Data?
    private var derivedIV: Data?

    private func deriveKeyAndIV(from password: String,
                                salt: Data) throws -> (key: Data, iv: Data) {
        let keyLength = kCCKeySizeAES256
        let ivLength = kCCBlockSizeAES128
        let totalLength = keyLength + ivLength
        var derivedBytes = [UInt8](repeating: 0, count: totalLength)

        let passwordData = password.data(using: .utf8)!
        let result = CCKeyDerivationPBKDF(
            CCPBKDFAlgorithm(kCCPBKDF2),
            password, passwordData.count,
            [UInt8](salt), salt.count,
            CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256),
            10000,
            &derivedBytes, totalLength
        )

        if result != kCCSuccess {
            throw CryptographyError.keyDerivationFailed
        }

        let key = Data(derivedBytes[0..<keyLength])
        let initialisationVector = Data(derivedBytes[keyLength..<totalLength])
        return (key, initialisationVector)
    }

    func syncKey(withPassword password: String, salt: Data) throws {
        let (key, initialisationVector) = try deriveKeyAndIV(from: password, salt: salt)
        try KeychainHelper.storeKey(key, forKey: "aes_key")
        try KeychainHelper.storeKey(initialisationVector, forKey: "aes_iv")
        derivedKey = key
        derivedIV = initialisationVector
    }

    func clearKey() throws {
        try KeychainHelper.removeKey("aes_key")
        try KeychainHelper.removeKey("aes_iv")
    }

    private func aesKey() throws -> Data {
        if let key = derivedKey {
            return key
        }
        if let key = try? KeychainHelper.retrieveKey(forKey: "aes_key") {
            return key
        } else {
            throw CryptographyError.keyGenerationFailed
        }
    }

    private func aesIV() throws -> Data {
        if let initialisationVector = derivedIV {
            return initialisationVector
        }
        if let initialisationVector = try? KeychainHelper.retrieveKey(forKey: "aes_iv") {
            return initialisationVector
        } else {
            throw CryptographyError.keyGenerationFailed
        }
    }

    func encrypt(_ data: Data) throws -> Data {
        return try aesOperation(data, operation: kCCEncrypt)
    }

    func decrypt(_ data: Data) throws -> Data {
        return try aesOperation(data, operation: kCCDecrypt)
    }

    private func aesOperation(_ data: Data, operation: Int) throws -> Data {
        let key = try aesKey()
        let initialisationVector = try aesIV()
        var outLength = Int(0)
        var outData = Data(count: data.count + kCCBlockSizeAES128)

        let keyLength = key.count
        if keyLength != kCCKeySizeAES256 {
            throw CryptographyError.invalidKeyLength
        }

        let options = CCOptions(kCCOptionPKCS7Padding)
        let outDatacount = outData.count

        let result = outData.withUnsafeMutableBytes { outBytes in
            data.withUnsafeBytes { dataBytes in
                initialisationVector.withUnsafeBytes { ivBytes in
                    key.withUnsafeBytes { keyBytes in
                        CCCrypt(
                            CCOperation(operation),
                            CCAlgorithm(kCCAlgorithmAES),
                            options,
                            keyBytes.baseAddress, keyLength,
                            ivBytes.baseAddress,
                            dataBytes.baseAddress, data.count,
                            outBytes.baseAddress, outDatacount,
                            &outLength
                        )
                    }
                }
            }
        }

        if result == kCCSuccess {
            outData.removeSubrange(outLength..<outData.count)
            return outData
        } else {
            if operation == kCCEncrypt {
                throw CryptographyError.encryptionFailed
            } else {
                throw CryptographyError.decryptionFailed
            }
        }
    }

}
