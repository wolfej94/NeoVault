//
//  AddImageFileTests.swift
//  NeoVault
//
//  Created by James Wolfe on 20/10/2024.
//

import XCTest

@MainActor
final class AddImageFileTests: XCTestCase {

    var app: XCUIApplication!
    var fileNameTextField: XCUIElement!
    var noImageSelectedLabel: XCUIElement!
    var submitButton: XCUIElement!
    var isOnAddImageView: Bool { app.navigationBars["Add Image File"].exists }

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launchArguments.append("UITest")
        app.launch()
        fileNameTextField = app.textFields["File Name"]
        noImageSelectedLabel = app.buttons["No image selected"]
        submitButton = app.buttons["Submit"]
        app.login()
        let financeFolder = app.buttons["Finance"]
        let foldersToLoad = existsExpectation(for: financeFolder)
        wait(for: [foldersToLoad])
        financeFolder.tap()
        let addFileButton = app.buttons["Add File"]
        addFileButton.tap()
        let addImageFileButton = app.sheets.firstMatch.buttons["Image"]
        addImageFileButton.tap()
    }

    override func tearDown() {
        super.tearDown()
        app = nil
        fileNameTextField = nil
        noImageSelectedLabel = nil
        submitButton = nil
    }

    func testInitialElements() {
        XCTAssertTrue(isOnAddImageView)
        XCTAssertTrue(fileNameTextField.exists)
        XCTAssertTrue(noImageSelectedLabel.exists)
        XCTAssertTrue(submitButton.exists)
    }

    func testSubmitDisabled() {
        XCTAssertFalse(submitButton.isEnabled)
        fileNameTextField.tap()
        fileNameTextField.typeText(TestData.fileName)
        XCTAssertFalse(submitButton.isEnabled)
        app.buttons["No image selected"].tap()
        app.images["Photo, 08 August 2012, 22:55"].tap()
        let submitIsEnabled = enabledExpectation(for: submitButton)
        wait(for: [submitIsEnabled])
    }

}

extension AddImageFileTests {
    struct TestData {
        static let fileName: String = "Test Image 2"
    }
}
