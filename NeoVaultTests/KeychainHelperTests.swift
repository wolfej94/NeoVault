//
//  KeychainHelperTests.swift
//  NeoVault
//
//  Created by James Wolfe on 07/10/2024.
//

import Testing
import UIKit
import CommonCrypto
@testable import Vault

@Suite("Keychain Helper")
struct KeychainHelperTests {

    @Test("Saved and loaded data match")
    func testSaveAndLoadData() throws {
        let key = "testKey"
        let data = "testData".data(using: .utf8)!

        try KeychainHelper.storeKey(data, forKey: key)
        let loadedData = try KeychainHelper.retrieveKey(forKey: key)
        #expect(loadedData == data)
    }

    @Test("Load non-existent data key throws")
    func testLoadNonExistentData() {
        do {
            _ = try KeychainHelper.retrieveKey(forKey: "nonExistentKey")
            Issue.record("should not retrieve any data")
        } catch {
            #expect(error as? KeychainHelperError != nil)
        }
    }

    @Test("Overwrite data succeeds")
    func testOverwriteData() throws {
        let key = "testKey"
        let oldData = "testData".data(using: .utf8)!

        try KeychainHelper.storeKey(oldData, forKey: key)
        let loadedData = try KeychainHelper.retrieveKey(forKey: key)
        #expect(loadedData == oldData)

        let newData = "newData".data(using: .utf8)!
        try KeychainHelper.storeKey(newData, forKey: key)
        let newLoadedData = try KeychainHelper.retrieveKey(forKey: key)
        #expect(newLoadedData == newData)
    }

}
