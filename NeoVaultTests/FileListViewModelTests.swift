//
//  FileListViewModelTests.swift
//  NeoVault
//
//  Created by James Wolfe on 17/10/2024.
//

import Testing
import UIKit
@testable import Vault

@Suite("File List View Model")
struct FileListViewModelTests {

    @Test("Selected file action actionHandler called correctly")
    func selectedFileActionHandlerCalledCorrectly() {
        var selectedFile: FileViewModel?
        let actionHandler: FileListAction.Handler = { action in
            switch action {
            case .selectedFile(let file):
                selectedFile = file
            default:
                break
            }
        }
        let subject = FileListViewModel(folderPath: "",
                                        fetchFilesCommand: { _ in [] },
                                        actionHandler: actionHandler)
        subject.selectFile(TestData.file)
        #expect(TestData.file == selectedFile)
    }

    @Test("Selected add file action actionHandler called correctly")
    func selectedAddFileActionHandlerCalledCorrectly() {
        var addFileSelected = false
        let actionHandler: FileListAction.Handler = { action in
            switch action {
            case .selectedAddFile:
                addFileSelected = true
            default:
                break
            }
        }
        let subject = FileListViewModel(folderPath: "",
                                        fetchFilesCommand: { _ in [] },
                                        actionHandler: actionHandler)
        subject.addFile()
        #expect(addFileSelected)
    }

    @Test("Failing to load sets state to error")
    func failingToLoadSetsStateToError() async {
        let subject = FileListViewModel(folderPath: "",
                                        fetchFilesCommand: { _ in throw TestData.errors.refresh  },
                                        actionHandler: { _ in })
        await subject.refresh()
        #expect(subject.state == .error(message: TestData.errors.refresh.localizedDescription))
    }

    @Test("Files are updated with results of refresh")
    func filesAreUpdatedWithResultsOfRefresh() async {
        let subject = FileListViewModel(folderPath: "",
                                        fetchFilesCommand: { _ in [TestData.file]  },
                                        actionHandler: { _ in })
        await subject.refresh()
        #expect(subject.files == [TestData.file])
    }

    @Test("Navigation title matches last path component",
          arguments: [
            ("foo/bar", "bar"),
            ("", "")
          ])
    func navigationTitleMatchesLastPathComponent(folderPath: String, expectedTitle: String) async {
        let subject = FileListViewModel(folderPath: folderPath,
                                        fetchFilesCommand: { _ in []  },
                                        actionHandler: { _ in })
        #expect(subject.navigationTitle == expectedTitle)
    }

    @Test("Show placeholder value is correct",
          arguments: [
            (true, [TestData.file], false),
            (false, [], false),
            (true, [], true)
          ]
    )
    func showPlaceholderValueIsCorrect(shouldRefresh: Bool, files: [FileViewModel], showPlaceholder: Bool) async {
        let subject = FileListViewModel(folderPath: "",
                                        fetchFilesCommand: { _ in files },
                                        actionHandler: { _ in })
        if shouldRefresh {
            await subject.refresh()
        }
        #expect(subject.showPlaceholder == showPlaceholder)
    }

}

extension FileListViewModelTests {
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
        static let file = FileViewModel(name: "", path: "", contentType: .document)
    }
}


