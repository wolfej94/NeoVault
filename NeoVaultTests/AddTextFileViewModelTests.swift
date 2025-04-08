//
//  Addtext.swift
//  NeoVault
//
//  Created by James Wolfe on 17/10/2024.
//

import UIKit
import Testing
@testable import Vault

@Suite("Add Text File View Model Tests")
struct AddTextFileViewModelTests {

    @Test("Submit disabled when appropriate",
          arguments: [
            ("", "Title", true),
            ("Text", "", true),
            ("", "", true),
            ("Text", "Title", false)
          ]
    )
    func submitDisabledWhenAppropriate(text: String, title: String, submitShouldBeDisabled: Bool) {
        let subject = AddTextFileViewModel(folderPath: "",
                                            actionHandler: { _ in },
                                            createFileCommand: { _, _, _, _ in },
                                            encryptDataCommand: { _ in Data() })
        subject.text = text
        subject.title = title
        #expect(subject.submitDisabled == submitShouldBeDisabled)
    }

    @Test("Data is equal to text data")
    func dataIsEqualToTextData() {
        let subject = AddTextFileViewModel(folderPath: "",
                                            actionHandler: { _ in },
                                            createFileCommand: { _, _, _, _ in },
                                            encryptDataCommand: { _ in Data() })
        let text = ""
        subject.text = text
        #expect(subject.data() == text.data(using: .utf8))
    }

    @Test("File added action called when file added succeeds")
    func fileAddedActionCalledWhenFileAddedSucceeds() async {
        var fileAddedCalled = false
        let actionHandler: AddFileViewModelAction.Handler = { action in
            switch action {
            case .fileAdded:
                fileAddedCalled = true
            }
        }
        let subject = AddTextFileViewModel(folderPath: "",
                                            actionHandler: actionHandler,
                                            createFileCommand: { _, _, _, _ in },
                                            encryptDataCommand: { _ in Data() })
        subject.text = "Test"
        await subject.submit()
        #expect(fileAddedCalled)
    }

    @Test("File added action not called when data is nil")
    func fileAddedActionNotCalledWhenDataIsNil() async {
        var fileAddedCalled = false
        let actionHandler: AddFileViewModelAction.Handler = { action in
            switch action {
            case .fileAdded:
                fileAddedCalled = true
            }
        }
        let subject = AddTextFileViewModel(folderPath: "",
                                            actionHandler: actionHandler,
                                            createFileCommand: { _, _, _, _ in },
                                            encryptDataCommand: { _ in Data() })
        await subject.submit()
        #expect(fileAddedCalled == false)
    }

    @Test("State is set to error when create file throws")
    func stateIsSetToErrorWhenCreateFileThrows() async {
        let createFileCommand: CreateFileCommand = { _, _, _, _ in
            throw TestData.errors.addText
        }
        let subject = AddTextFileViewModel(folderPath: "",
                                            actionHandler: { _ in },
                                            createFileCommand: createFileCommand,
                                            encryptDataCommand: { _ in Data() })
        subject.text = "Test"
        await subject.submit()
        #expect(subject.state == .error(message: TestData.errors.addText.localizedDescription))
    }

    @Test("State is set to error when encrypt throws")
    func stateIsSetToErrorWhenEncryptThrows() async {
        let encrypDataCommand: EncryptDataCommand = { _ in
            throw TestData.errors.encrypt
        }
        let subject = AddTextFileViewModel(folderPath: "",
                                            actionHandler: { _ in },
                                            createFileCommand: { _, _, _, _ in },
                                            encryptDataCommand: encrypDataCommand)
        subject.text = "Test"
        await subject.submit()
        #expect(subject.state == .error(message: TestData.errors.encrypt.localizedDescription))
    }

    @Test("Progress updates as file is created",
          arguments: [
            50,
            nil
          ]
    )
    func progressUpdatesAsFolderIsCreated(completedUnitCount: Int64?) async {
        let progress = completedUnitCount == nil ? nil : Progress(totalUnitCount: 100)
        progress?.completedUnitCount = completedUnitCount ?? 0

        let createFileCommand: CreateFileCommand = { _, _, _, onProgress in
            onProgress?(progress)
        }
        let subject = AddTextFileViewModel(folderPath: "",
                                            actionHandler: { _ in },
                                            createFileCommand: createFileCommand,
                                            encryptDataCommand: { _ in Data() })
        subject.text = "Test"
        await subject.submit()
        #expect(subject.progress == (Double(completedUnitCount ?? 0 / 100) / 100))
    }

    @Test("Content type is document when creating file")
    func contentTypeIsCorrectWhenCreatingFile() async {
        var selectedContentType: FileType?
        let createFileCommand: CreateFileCommand = { _, _, contentType, _ in
            selectedContentType = contentType
        }
        let subject = AddTextFileViewModel(folderPath: "",
                                            actionHandler: { _ in },
                                            createFileCommand: createFileCommand,
                                            encryptDataCommand: { _ in Data() })
        subject.text = "Test"
        await subject.submit()
        #expect(selectedContentType == .document)
    }

}

extension AddTextFileViewModelTests {
    struct TestData {
        enum errors: LocalizedError {
            case addText
            case encrypt

            var errorDescription: String? {
                switch self {
                case .addText:
                    "Add Text"
                case .encrypt:
                    "Encrypt"
                }
            }
        }
    }
}
