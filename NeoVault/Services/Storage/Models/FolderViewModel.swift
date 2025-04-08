//
//  FolderViewModel.swift
//  NeoVault
//
//  Created by James Wolfe on 11/11/2024.
//

import Foundation
import LocalStoragePlatform

 struct FolderViewModel: Equatable, Hashable {

    let name: String
    let path: String
    let files: [FileViewModel]
    let contentCount: Int
    let contentSize: Double

    var fileTypeSizes: [FileType: Double] {
        var dictionary = [FileType: Double]()
        for fileType in FileType.allCases {
            dictionary[fileType] = files
                .filter({ $0.fileType == fileType })
                .reduce(into: .zero, { $0 += $1.size })
        }
        return dictionary
    }

    init(local: LocalFolder) {
        self.name = local.name
        self.path = local.url.relativePath

        let files: [FileViewModel] = local.files
            .map { FileViewModel(local: $0) }
        self.files = files
        self.contentCount = files.count
        self.contentSize = files.reduce(into: .zero, { $0 += $1.size })
    }
}
