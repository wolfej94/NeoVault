//
//  ViewTextFileViewModelTests.swift
//  NeoVault
//
//  Created by James Wolfe on 18/10/2024.
//

import Testing
import UIKit
@testable import Vault

@Suite("View Text File View Model")
struct ViewTextFileViewModelTests {

    @Test("Refresh sets state to error when file contents fails")
    func refreshSetsStateToErrorWhenFileContentsFails() async {
        let subject = ViewTextFileViewModel(
            file: TestData.file,
            actionHandler: { _ in },
            fileContentsCommand: { _ in throw TestData.errors.fileContents },
            decryptCommand: { _ in return String() }
        )
        await subject.refresh()
        #expect(subject.state == .error(message: TestData.errors.fileContents.localizedDescription))
    }

    @Test("Refresh sets state to error when decrypy fails")
    func refreshSetsStateToErrorWhenDecryptFails() async {
        let subject = ViewTextFileViewModel(
            file: TestData.file,
            actionHandler: { _ in },
            fileContentsCommand: { _ in return Data() },
            decryptCommand: { _ in throw TestData.errors.decrypt }
        )
        await subject.refresh()
        #expect(subject.state == .error(message: TestData.errors.decrypt.localizedDescription))
    }

    @Test("File content populates value on view model")
    func FileContentsPopulatesValueOnViewModel() async throws {
        let data = try TestData.data()
        let subject = ViewTextFileViewModel(
            file: TestData.file,
            actionHandler: { _ in },
            fileContentsCommand: { _ in data },
            decryptCommand: { _ in String() }
        )
        await subject.refresh()
        #expect(subject.fileContents == data)
    }

    @Test("Decrypt image populates value on view model")
    func decryptImagePopulatesValueOnViewModel() async throws {
        let text = try TestData.text()
        let subject = ViewTextFileViewModel(
            file: TestData.file,
            actionHandler: { _ in },
            fileContentsCommand: { _ in Data() },
            decryptCommand: { _ in text }
        )
        await subject.refresh()
        #expect(subject.text == text)
    }

}

extension ViewTextFileViewModelTests {
    struct TestData {
        enum errors: LocalizedError {
            case fileContents
            case decrypt
            case unknown

            var errorDescription: String? {
                switch self {
                case .decrypt:
                    "Decrypt"
                case .fileContents:
                    "File Contents"
                case .unknown:
                    "This should not be called."
                }
            }
        }
        static let file = FileViewModel(name: "", path: "", contentType: .document)

        static func data() throws -> Data {
            let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            let string = String((0..<10).map{ _ in characters.randomElement()! })
            guard let data = string.data(using: .utf8) else {
                throw errors.unknown
            }
            return data
        }

        static func text() throws -> String {
            guard let text = try String(data: data(), encoding: .utf8) else {
                throw errors.unknown
            }
            return text
        }
    }
}
