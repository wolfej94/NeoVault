//
//  LocalFile.swift
//  LocalStoragePlatform
//
//  Created by James Wolfe on 13/11/2024.
//

import Foundation
import UniformTypeIdentifiers

public struct LocalFile: Identifiable, Equatable, Hashable {
    public let name: String
    public let type: UTType
    public let url: URL

    public var data: Data? {
        try? Data(contentsOf: url)
    }

    public var size: Double {
        Double(data?.count ?? .zero) / (1024 * 1024)
    }

    public var contentType: String {
        type.preferredMIMEType ?? "plain/text"
    }

    public var id: String {
        url.absoluteString
    }

    internal init(url: URL) {
        let type = UTType.init(filenameExtension: url.pathExtension)
        self.name = url.lastPathComponent
        self.type = type ?? .plainText
        self.url = url
    }
}
