//
//  Data+RandomSalt.swift
//  NeoVault
//
//  Created by James Wolfe on 21/10/2024.
//

import Foundation

extension Data {

    static func randomSalt(length: Int) -> Data? {
        var salt = Data(count: length)
        let result = salt.withUnsafeMutableBytes { buffer in
            SecRandomCopyBytes(kSecRandomDefault, length, buffer.baseAddress!)
        }

        return result == errSecSuccess ? salt : nil
    }

}
