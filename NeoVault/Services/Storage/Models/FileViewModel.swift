//
//  FileViewModel.swift
//  NeoVault
//
//  Created by James Wolfe on 11/11/2024.
//

import Foundation
import LocalStoragePlatform

struct FileViewModel: Equatable, Hashable {
    let name: String
    let path: String
    let contentType: String
    let size: Double
    var contents: URL?

    var fileType: FileType {
        FileType(mimeType: contentType)
    }

    init(local: LocalFile) {
        self.name = local.name
        self.path = local.url.relativePath
        self.contentType = local.contentType
        self.contents = local.url
        self.size = local.size
    }

    init(name: String,
         path: String,
         contentType: String,
         size: Double,
         contents: URL?) {
        self.name = name
        self.path = path
        self.contentType = contentType
        self.size = size
        self.contents = contents
    }
}
