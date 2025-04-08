//
//  AddImageFileViewModelTests.swift
//  NeoVault
//
//  Created by James Wolfe on 17/10/2024.
//

import UIKit
import Testing
@testable import Vault

@Suite("Add Image File View Model Tests")
struct AddImageFileViewModelTests {

    @Test("Submit disabled when appropriate",
          arguments: [
            (nil, "Title", true),
            (Data(), "", true),
            (nil, "", true),
            (Data(), "Title", false)
          ]
    )
    func submitDisabledWhenAppropriate(imageData: Data?, title: String, submitShouldBeDisabled: Bool) {
        let subject = AddImageFileViewModel(folderPath: "",
                                            actionHandler: { _ in },
                                            createFileCommand: { _, _, _, _ in },
                                            encryptDataCommand: { _ in Data() })
        subject.imageData = imageData
        subject.title = title
        #expect(subject.submitDisabled == submitShouldBeDisabled)
    }

    @Test("Data is equal to image data")
    func dataIsEqualToImageData() {
        let subject = AddImageFileViewModel(folderPath: "",
                                            actionHandler: { _ in },
                                            createFileCommand: { _, _, _, _ in },
                                            encryptDataCommand: { _ in Data() })
        let data = Data()
        subject.imageData = data
        #expect(subject.data() == data)
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
        let subject = AddImageFileViewModel(folderPath: "",
                                            actionHandler: actionHandler,
                                            createFileCommand: { _, _, _, _ in },
                                            encryptDataCommand: { _ in Data() })
        subject.imageData = Data()
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
        let subject = AddImageFileViewModel(folderPath: "",
                                            actionHandler: actionHandler,
                                            createFileCommand: { _, _, _, _ in },
                                            encryptDataCommand: { _ in Data() })
        await subject.submit()
        #expect(fileAddedCalled == false)
    }

    @Test("State is set to error when create file throws")
    func stateIsSetToErrorWhenCreateFileThrows() async {
        let createFileCommand: CreateFileCommand = { _, _, _, _ in
            throw TestData.errors.addImage
        }
        let subject = AddImageFileViewModel(folderPath: "",
                                            actionHandler: { _ in },
                                            createFileCommand: createFileCommand,
                                            encryptDataCommand: { _ in Data() })
        subject.imageData = Data()
        await subject.submit()
        #expect(subject.state == .error(message: TestData.errors.addImage.localizedDescription))
    }

    @Test("State is set to error when encrypt throws")
    func stateIsSetToErrorWhenEncryptThrows() async {
        let encrypDataCommand: EncryptDataCommand = { _ in
            throw TestData.errors.encrypt
        }
        let subject = AddImageFileViewModel(folderPath: "",
                                            actionHandler: { _ in },
                                            createFileCommand: { _, _, _, _ in },
                                            encryptDataCommand: encrypDataCommand)
        subject.imageData = Data()
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
        let subject = AddImageFileViewModel(folderPath: "",
                                            actionHandler: { _ in },
                                            createFileCommand: createFileCommand,
                                            encryptDataCommand: { _ in Data() })
        subject.imageData = Data()
        await subject.submit()
        #expect(subject.progress == (Double(completedUnitCount ?? 0 / 100) / 100))
    }

    @Test("Is content type is image when creating file")
    func contentTypeIsCorrectWhenCreatingFile() async {
        var selectedContentType: FileType?
        let createFileCommand: CreateFileCommand = { _, _, contentType, _ in
            selectedContentType = contentType
        }
        let subject = AddImageFileViewModel(folderPath: "",
                                            actionHandler: { _ in },
                                            createFileCommand: createFileCommand,
                                            encryptDataCommand: { _ in Data() })
        subject.imageData = Data()
        await subject.submit()
        #expect(selectedContentType == .image)
    }

}

extension AddImageFileViewModelTests {
    struct TestData {
        enum errors: LocalizedError {
            case addImage
            case encrypt

            var errorDescription: String? {
                switch self {
                case .addImage:
                    "Add Image"
                case .encrypt:
                    "Encrypt"
                }
            }
        }
    }
}
