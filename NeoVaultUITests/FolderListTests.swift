//
//  FolderListTests.swift
//  NeoVault
//
//  Created by James Wolfe on 20/10/2024.
//

import XCTest

@MainActor
final class FolderListTests: XCTestCase {

    var app: XCUIApplication!
    var addButton: XCUIElement!
    var folder: XCUIElement!
    var emptyListLabel: XCUIElement!
    var isOnFoldersView: Bool { app.navigationBars["Folders"].exists }
    var isOnFileListView: Bool { app.navigationBars["Finance"].exists }
    var isOnAddFolderView: Bool { app.navigationBars["Add Folder"].exists }

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launchArguments.append("UITest")
        app.launch()
        emptyListLabel = app.staticTexts["No folders yet"]
        addButton = app.navigationBars.firstMatch.buttons["Add Folder"]
        folder = app.buttons["Finance"]
        app.login()
        let foldersToLoad = existsExpectation(for: folder)
        wait(for: [foldersToLoad])
    }

    override func tearDown() {
        super.tearDown()
        addButton = nil
        folder = nil
    }

    func testInitialElements() {
        XCTAssertTrue(addButton.exists)
        XCTAssertTrue(folder.exists)
        XCTAssertTrue(isOnFoldersView)
        XCTAssertFalse(isOnFileListView)
        XCTAssertFalse(emptyListLabel.exists)
    }

    func testFolderNavigation() {
        folder.tap()
        XCTAssertTrue(isOnFileListView)
    }

    func testAddNavigation() {
        addButton.tap()
        XCTAssertTrue(isOnAddFolderView)
    }

}
