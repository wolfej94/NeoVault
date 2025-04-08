//
//  AddFileViewModelTests.swift
//  NeoVault
//
//  Created by James Wolfe on 18/10/2024.
//

import UIKit
import Testing
@testable import Vault

@Suite("Add File View Model Tests")
struct AddFileViewModelTests {

    @Test("Submit disabled never")
    func submitDisabledNever() {
        let subject = AddFileViewModel(folderPath: "",
                                       actionHandler: { _ in },
                                       createFileCommand: { _, _, _, _ in },
                                       encryptDataCommand: { _ in Data() },
                                       contentType: .document)
        #expect(subject.submitDisabled == false)
    }

    @Test("Data is always nil")
    func dataIsAlwaysNil() {
        let subject = AddFileViewModel(folderPath: "",
                                       actionHandler: { _ in },
                                       createFileCommand: { _, _, _, _ in },
                                       encryptDataCommand: { _ in Data() },
                                       contentType: .document)
        #expect(subject.data() == nil)
    }

    @Test("File added action never called")
    func fileAddedActioNeverCalled() async {
        var fileAddedCalled = false
        let actionHandler: AddFileViewModelAction.Handler = { action in
            switch action {
            case .fileAdded:
                fileAddedCalled = true
            }
        }
        let subject = AddFileViewModel(folderPath: "",
                                       actionHandler: actionHandler,
                                       createFileCommand: { _, _, _, _ in },
                                       encryptDataCommand: { _ in Data() },
                                       contentType: .document)
        await subject.submit()
        #expect(fileAddedCalled == false)
    }

}
