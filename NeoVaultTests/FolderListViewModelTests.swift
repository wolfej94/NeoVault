//
//  FolderListViewModelTests.swift
//  NeoVault
//
//  Created by James Wolfe on 17/10/2024.
//

import Testing
import UIKit
@testable import Vault

@Suite("Folder List View Model")
struct FolderListViewModelTests {

    @Test("Selected folder action actionHandler called correctly")
    func selectedFolderActionHandlerCalledCorrectly() async throws {
        var selectedFolderPath: String?
        let actionHandler: FolderListAction.Handler = { action in
            switch action {
            case .selectedFolder(let path):
                selectedFolderPath = path
            default:
                break
            }
        }
        let subject = FolderListViewModel(fetchFoldersCommand: { [TestData.folder] },
                                          actionHandler: actionHandler,
                                          userNameCommand: { "" })
        await subject.refresh()
        subject.select(folder: TestData.folder)
        #expect(selectedFolderPath == TestData.folder.path)
    }

    @Test("Selected add folder action actionHandler called correctly")
    func selectedAddFolderActionHandlerCalledCorrectly() {
        var addFolderSelected = false
        let actionHandler: FolderListAction.Handler = { action in
            switch action {
            case .selectedAddFolder:
                addFolderSelected = true
            default:
                break
            }
        }
        let subject = FolderListViewModel(fetchFoldersCommand: { [] },
                                          actionHandler: actionHandler,
                                          userNameCommand: { ""})
        subject.addFolder()
        #expect(addFolderSelected)
    }

    @Test("Failing to load sets state to error")
    func failingToLoadSetsStateToError() async {
        let subject = FolderListViewModel(fetchFoldersCommand: { throw TestData.errors.refresh  },
                                          actionHandler: { _ in },
                                          userNameCommand: { "" })
        await subject.refresh()
        #expect(subject.state == .error(message: TestData.errors.refresh.localizedDescription))
    }

    @Test("Folders are updated with results of refresh",
          arguments: [
            [TestData.folder],
            []
          ]
    )
    func foldersAreUpdatedWithResultsOfRefresh(folders: [FolderViewModel]) async throws {
        let subject = FolderListViewModel(fetchFoldersCommand: { folders },
                                          actionHandler: { _ in },
                                          userNameCommand: { "" })
        await subject.refresh()
        #expect(subject.folders == folders)
    }

    @Test("Show placeholder value is correct",
          arguments: [
            (true, [TestData.folder], false),
            (false, [], false),
            (true, [], true)
          ]
    )
    func showPlaceholderValueIsCorrect(shouldRefresh: Bool, folders: [FolderViewModel], showPlaceholder: Bool) async throws {
        let subject = FolderListViewModel(fetchFoldersCommand: { folders },
                                          actionHandler: { _ in },
                                          userNameCommand: { "" })
        if shouldRefresh {
            await subject.refresh()
        }
        #expect(subject.showPlaceholder == showPlaceholder)
    }

}

extension FolderListViewModelTests {
    struct TestData {
        enum errors: LocalizedError {
            case refresh

            var errorDescription: String? {
                switch self {
                case .refresh:
                    "Test"
                }
            }
        }
        static let folder = FolderViewModel(
            name: "bar",
            fileCount: 0,
            size: 0,
            path: "foo/bar"
        )
    }
}


