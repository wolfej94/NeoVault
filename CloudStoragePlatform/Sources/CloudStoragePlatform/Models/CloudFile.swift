//
//  CloudFile.swift
//  StoragePlatform
//
//  Created by James Wolfe on 08/11/2024.
//

import Foundation

public struct CloudFile: Sendable {
    public let name: String
    public let path: String
    public let contentType: String
    public let size: Double
    public var contents: Data

    internal init(name: String, path: String, contentType: String, contents: Data) {
        self.name = name
        self.path = path
        self.contentType = contentType
        self.contents = contents
        self.size = Double(contents.count ?? .zero) / (1024 * 1024)
    }
}
