//
//  FileViewModelTests.swift
//  NeoVault
//
//  Created by James Wolfe on 17/10/2024.
//

import Testing
@testable import Vault

@Suite("File View Model")
struct FileViewModelTests {

    @Test("Test is image returns correct value",
          arguments: [
            FileType.image,
            FileType.document,
            FileType.video,
            FileType.music,
          ]
    )
    func contentTypeReturnsCorrectValue(_ contentType: FileType) {
        let file = FileViewModel(name: "", path: "", contentType: contentType)
        #expect(file.contentType == contentType)

    }
}
