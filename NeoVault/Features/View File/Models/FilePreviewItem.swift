//
//  FilePreviewItem.swift
//  NeoVault
//
//  Created by James Wolfe on 13/11/2024.
//

import QuickLook
import Foundation

final class FilePreviewItem: Hashable, Equatable {

    let name: String
    let data: Data
    let path: String

    init(name: String, data: Data, path: String) {
        self.name = name
        self.data = data
        self.path = path
    }

    lazy var url: URL? = {
        guard let path = path.components(separatedBy: "/").last else { return nil}
        let url = URL.temporaryDirectory.appending(path: path)
        let success = FileManager.default.createFile(atPath: url.relativePath, contents: data)
        return success ? url : nil
    }()

    static func == (lhs: FilePreviewItem, rhs: FilePreviewItem) -> Bool {
        lhs.name == rhs.name &&
        lhs.data == rhs.data &&
        lhs.path == rhs.path
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(data)
        hasher.combine(path)
    }
}
