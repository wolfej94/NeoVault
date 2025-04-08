//
//  ViewImageFileViewModelTests.swift
//  NeoVault
//
//  Created by James Wolfe on 17/10/2024.
//

import UIKit
@testable import Vault
import Testing

@Suite("View Image File View Model")
struct ViewImageFileViewModelTests {

    @Test("Refresh sets state to error when file contents fails")
    func refreshSetsStateToErrorWhenFileContentsFails() async {
        let subject = ViewImageFileViewModel(
            file: TestData.file,
            fileContentsCommand: { _ in throw TestData.errors.fileContents },
            decryptCommand: { _ in return UIImage() }
        )
        await subject.refresh()
        #expect(subject.state == .error(message: TestData.errors.fileContents.localizedDescription))
    }

    @Test("Refresh sets state to error when decrypy fails")
    func refreshSetsStateToErrorWhenDecryptFails() async {
        let subject = ViewImageFileViewModel(
            file: TestData.file,
            fileContentsCommand: { _ in return Data() },
            decryptCommand: { _ in throw TestData.errors.decrypt }
        )
        await subject.refresh()
        #expect(subject.state == .error(message: TestData.errors.decrypt.localizedDescription))
    }

    @Test("File content populates value on view model")
    func FileContentsPopulatesValueOnViewModel() async throws {
        let data = try await TestData.data()
        let subject = ViewImageFileViewModel(
            file: TestData.file,
            fileContentsCommand: { _ in data },
            decryptCommand: { _ in UIImage() }
        )
        await subject.refresh()
        #expect(subject.fileContents == data)
    }

    @Test("Decrypt image populates value on view model")
    func decryptImagePopulatesValueOnViewModel() async throws {
        let image = try await TestData.image()
        let subject = ViewImageFileViewModel(
            file: TestData.file,
            fileContentsCommand: { _ in Data() },
            decryptCommand: { _ in image }
        )
        await subject.refresh()
        #expect(subject.image == image)
    }

}

extension ViewImageFileViewModelTests {
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
        static let file = Vault.FileViewModel(name: "", path: "", contentType: .image)

        static func data() async throws -> Data {
            guard let url = URL(string: "https://picsum.photos/200") else {
                throw errors.unknown
            }

            return try await URLSession.shared.data(from: url).0
        }

        static func image() async throws -> UIImage {
            guard let image = try await UIImage(data: data()) else {
                throw errors.unknown
            }
            return image
        }
    }
}
