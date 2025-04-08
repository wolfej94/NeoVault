//
//  Configuration.swift
//  NeoVault
//
//  Created by James Wolfe on 15/11/2024.
//

import Foundation

// swiftlint: disable force_cast
struct Configuration {
    static let wasabiKey = Bundle.main.object(forInfoDictionaryKey: "WASABI_KEY") as! String
    static let wasabiSecret = Bundle.main.object(forInfoDictionaryKey: "WASABI_SECRET") as! String
    static let wasabiBucket = Bundle.main.object(forInfoDictionaryKey: "WASABI_BUCKET") as! String
}
// swiftlint: enable force_cast
