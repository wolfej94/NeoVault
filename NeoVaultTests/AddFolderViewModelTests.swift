//
//  ViewTestFileViewModelTests.swift
//  NeoVault
//
//  Created by James Wolfe on 17/10/2024.
//

import Testing
import UIKit
@testable import Vault

@Suite("Add Folder View Model")
struct AddFolderViewModelTests {

    @Test("Submit calls action actionHandler on success")
    func submitCallsActionHandlerOnSuccess() async {
        var folderCreatedCalled = false
        let addFolderActionHandler: AddFolderViewModelAction.Handler = { action in
            switch action {
            case .folderCreated:
                folderCreatedCalled = true
            }
        }
        let subject = AddFolderViewModel(addFolderCommand: { _, _ in },
                                         actionHandler: addFolderActionHandler)
        await subject.submit()
        #expect(folderCreatedCalled)
    }

    @Test("Submit sets state to error on failure")
    func submitSetsStateToErrorOnFailure() async {
        let subject = AddFolderViewModel(addFolderCommand: { _, _ in throw TestData.errors.addFolder },
                                         actionHandler: { _ in })
        await subject.submit()
        #expect(subject.state == .error(message: TestData.errors.addFolder.localizedDescription))
    }

    @Test("Progress updates as folder is created",
          arguments: [
            50,
            nil
          ]
    )
    func progressUpdatesAsFolderIsCreated(completedUnitCount: Int64?) async {
        let progress = completedUnitCount == nil ? nil : Progress(totalUnitCount: 100)
        progress?.completedUnitCount = completedUnitCount ?? 0

        let addFolderCommand: AddFolderCommand = { _, onProgress in
            onProgress?(progress)
        }
        let subject = AddFolderViewModel(
            addFolderCommand: addFolderCommand,
            actionHandler: { _ in }
        )
        await subject.submit()
        #expect(subject.progress == (Double(completedUnitCount ?? 0 / 100) / 100))
    }

}

extension AddFolderViewModelTests {
    struct TestData {
        enum errors: LocalizedError {
            case addFolder

            var errorDescription: String? {
                switch self {
                case .addFolder:
                    "Test"
                }
            }
        }
    }
}
