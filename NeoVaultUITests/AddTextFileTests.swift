//
//  AddTextFileTests.swift
//  NeoVault
//
//  Created by James Wolfe on 20/10/2024.
//

import XCTest

@MainActor
final class AddTextFileTests: XCTestCase {

    var app: XCUIApplication!
    var fileNameTextField: XCUIElement!
    var textEditor: XCUIElement!
    var submitButton: XCUIElement!
    var isOnAddTextView: Bool { app.navigationBars["Add Text File"].exists }

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launchArguments.append("UITest")
        app.launch()
        fileNameTextField = app.textFields["File Name"]
        textEditor = app.textViews.firstMatch
        submitButton = app.buttons["Submit"]
        app.login()
        let financeFolder = app.buttons["Finance"]
        let foldersToLoad = existsExpectation(for: financeFolder)
        wait(for: [foldersToLoad])
        financeFolder.tap()
        let addFileButton = app.buttons["Add File"]
        addFileButton.tap()
        let addTextFileButton = app.sheets.firstMatch.buttons["Text"]
        addTextFileButton.tap()
    }

    override func tearDown() {
        super.tearDown()
        app = nil
        fileNameTextField = nil
        textEditor = nil
        submitButton = nil
    }

    func testInitialElements() {
        XCTAssertTrue(isOnAddTextView)
        XCTAssertTrue(fileNameTextField.exists)
        XCTAssertTrue(textEditor.exists)
        XCTAssertTrue(submitButton.exists)
    }

    func testSubmitDisabled() {
        XCTAssertFalse(submitButton.isEnabled)
        fileNameTextField.tap()
        fileNameTextField.typeText(TestData.fileName)
        XCTAssertFalse(submitButton.isEnabled)
        textEditor.tap()
        textEditor.typeText(TestData.text)
        XCTAssertTrue(submitButton.isEnabled)
    }

}

extension AddTextFileTests {
    struct TestData {
        static let fileName: String = "Test Image 2"
        static let text: String = "awdawdawd"
    }
}
