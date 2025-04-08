//
//  CloudFile.swift
//  StoragePlatform
//
//  Created by James Wolfe on 08/11/2024.
//

public struct CloudFolder: Sendable {
    public let name: String
    public let path: String
    public let files: [CloudFile]
    public let contentCount: Int
    public let contentSize: Double

    internal init(name: String, path: String, files: [CloudFile]) {
        self.name = name
        self.path = path
        self.files = files
        self.contentCount = files.count
        self.contentSize = files.reduce(into: .zero, { $0 += $1.size })
    }
}
