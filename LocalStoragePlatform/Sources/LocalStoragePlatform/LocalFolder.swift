//
//  LocalFolder.swift
//  LocalStoragePlatform
//
//  Created by James Wolfe on 13/11/2024.
//

import Foundation

public struct LocalFolder: Identifiable, Equatable, Hashable, @unchecked Sendable {
    public let name: String
    public let files: [LocalFile]
    public let url: URL

    public var id: String {
        url.absoluteString
    }

    internal init(url: URL, files: [LocalFile]) {
        self.name = url.lastPathComponent.replacingOccurrences(of: "vault_", with: "")
        self.files = files
        self.url = url
    }
}
