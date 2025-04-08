//
//  KeychainHelper.swift
//  NeoVault
//
//  Created by James Wolfe on 07/10/2024.
//

import Foundation
import CommonCrypto
import Security

enum KeychainHelperError: Error {
    case keychainErrorWithCode(OSStatus)
}

final class KeychainHelper {

    static func storeKey(_ key: Data, forKey keyName: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keyName
        ]

        var addQuery = query
        addQuery[kSecValueData as String] = key
        let addStatus = SecItemAdd(addQuery as CFDictionary, nil)

        if addStatus == errSecDuplicateItem {
            let attributesToUpdate: [String: Any] = [
                kSecValueData as String: key
            ]
            let updateStatus = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            guard updateStatus == errSecSuccess else {
                throw KeychainHelperError.keychainErrorWithCode(updateStatus)
            }
        } else if addStatus != errSecSuccess {
            throw KeychainHelperError.keychainErrorWithCode(addStatus)
        }
    }

    static func removeKey(_ keyName: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keyName
        ]

        let deleteStatus = SecItemDelete(query as CFDictionary)
        if deleteStatus != errSecSuccess && deleteStatus != errSecItemNotFound {
            throw KeychainHelperError.keychainErrorWithCode(deleteStatus)
        }
    }

    static func retrieveKey(forKey keyName: String) throws -> Data {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keyName,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess else {
            throw KeychainHelperError.keychainErrorWithCode(status)
        }

        guard let key = result as? Data else {
            throw KeychainHelperError.keychainErrorWithCode(status)
        }
        return key
    }

}
