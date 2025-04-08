//
//  FileListTests.swift
//  NeoVault
//
//  Created by James Wolfe on 20/10/2024.
//

import XCTest

final class FileListTests: XCTestCase {

    var app: XCUIApplication!
    var addButton: XCUIElement!
    var imageFile: XCUIElement!
    var textFile: XCUIElement!
    var emptyFolderLabel: XCUIElement!
    var addDialogueTitleLabel: XCUIElement!
    var addDialogueMessageLabel: XCUIElement!
    var addDialogueTextButton: XCUIElement!
    var addDialogueImageButton: XCUIElement!
    var isOnAddTextFileView: Bool { app.navigationBars["Add Text File"].exists }
    var isOnAddImageFileView: Bool { app.navigationBars["Add Image File"].exists }
    var isOnViewTextFileView: Bool { app.navigationBars["Test File"].exists }
    var isOnViewImageFileView: Bool { app.navigationBars["Test Image"].exists }
    var isInChildrenFolder: Bool { app.navigationBars["Children"].exists }
    var isInFinanceFolder: Bool { app.navigationBars["Finance"].exists }

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launchArguments.append("UITest")
        app.launch()
        emptyFolderLabel = app.staticTexts["No files in \"Children\""]
        addButton = app.navigationBars.firstMatch.buttons["Add File"]
        imageFile = app.buttons["Test Image"]
        textFile = app.buttons["Test File"]
        addDialogueTitleLabel = app.sheets.firstMatch.staticTexts["Choose an option"]
        addDialogueMessageLabel = app.sheets.firstMatch.staticTexts["Please select one of the following options."]
        addDialogueTextButton = app.sheets.firstMatch.buttons["Text"]
        addDialogueImageButton = app.sheets.firstMatch.buttons["Image"]
        app.login()
    }

    override func tearDown() {
        super.tearDown()
        addButton = nil
        imageFile = nil
        textFile = nil
        emptyFolderLabel = nil
        addDialogueTitleLabel = nil
        addDialogueMessageLabel = nil
        addDialogueTextButton = nil
        addDialogueImageButton = nil
    }

    func testInitialElements() {
        navigateToFinance()
        XCTAssertTrue(isInFinanceFolder)
        XCTAssertTrue(addButton.exists)
        XCTAssertTrue(imageFile.exists)
        XCTAssertTrue(textFile.exists)
        XCTAssertFalse(emptyFolderLabel.exists)
        XCTAssertFalse(isInChildrenFolder)
        XCTAssertFalse(addDialogueTitleLabel.exists)
        XCTAssertFalse(addDialogueMessageLabel.exists)
        XCTAssertFalse(addDialogueTextButton.exists)
        XCTAssertFalse(addDialogueImageButton.exists)
    }

    func testEmptyFolderPlaceholder() {
        navigateToChildren()
        XCTAssertTrue(isInChildrenFolder)
        XCTAssertTrue(emptyFolderLabel.exists)
    }

    func testAddNavigation() {
        navigateToFinance()
        addButton.tap()
        XCTAssertTrue(addDialogueTitleLabel.exists)
        XCTAssertTrue(addDialogueMessageLabel.exists)
        XCTAssertTrue(addDialogueTextButton.exists)
        XCTAssertTrue(addDialogueImageButton.exists)
    }

    func testAddTextFileNavigation() {
        navigateToFinance()
        addButton.tap()
        addDialogueTextButton.tap()
        XCTAssertTrue(isOnAddTextFileView)
    }

    func testAddImageFileNavigation() {
        navigateToFinance()
        addButton.tap()
        addDialogueImageButton.tap()
        XCTAssertTrue(isOnAddImageFileView)
    }

    func testViewTextFileNavigation() {
        navigateToFinance()
        textFile.tap()
        XCTAssertTrue(isOnViewTextFileView)
    }

    func testViewImageFileNavigation() {
        navigateToFinance()
        imageFile.tap()
        XCTAssertTrue(isOnViewImageFileView)
    }
}

private extension FileListTests {
    func navigateToFinance() {
        let financeFolder = app.buttons["Finance"]
        let foldersToLoad = existsExpectation(for: financeFolder)
        wait(for: [foldersToLoad])
        financeFolder.tap()
    }

    func navigateToChildren() {
        let childrenFolder = app.buttons["Children"]
        let foldersToLoad = existsExpectation(for: childrenFolder)
        wait(for: [foldersToLoad])
        childrenFolder.tap()
    }
}
