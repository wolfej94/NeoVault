//
//  CryptographyServiceTests.swift
//  NeoVault
//
//  Created by James Wolfe on 07/10/2024.
//

import Testing
import UIKit
import CommonCrypto
@testable import Vault

@Suite("Cryptography Service")
struct CryptographyServiceTests {

    let cryptographyService: CryptographyService

    init() throws {
        cryptographyService = DefaultCryptographyService()
    }

    @Test("Encrypted string matches decrypted string")
    func testEncryptionDecryptionString() throws {
        let data = try #require("Hello, World!".data(using: .utf8))

        let encryptedData = try cryptographyService.encrypt(data)
        let decryptedData = try cryptographyService.decryptText(encryptedData)

        #expect(String(data: data, encoding: .utf8) == decryptedData)
    }

    @Test("Encrypted image matches decrypted image")
    func testEncryptionDecryptionImage() async throws {
        let url = try #require(URL(string: "https://picsum.photos/200/300"))
        let imageData = try await URLSession.shared.data(from: url, delegate: nil).0
        let image = try #require(UIImage(data: imageData))

        let encryptedData = try cryptographyService.encrypt(imageData)
        let decryptedData = try cryptographyService.decryptImage(encryptedData)

        #expect(image.pngData() == decryptedData.pngData())
    }

    @Test("Decryption of images throws with invalid data")
    func testDecryptImageThrowsWithInvalidData() throws {
        let data = Data([0])
        do {
            _ = try cryptographyService.decryptImage(data)
        } catch {
            #expect(error as? CryptographyError == CryptographyError.invalidImageData)
        }
    }

    @Test("Decryption of strings throws with invalid data")
    func testDecryptStringThrowsWithInvalidData() throws {
        let data = Data([0])
        do {
            _ = try cryptographyService.decryptText(data)
        } catch {
            #expect(error as? CryptographyError == CryptographyError.invalidTextData)
        }
    }

}
