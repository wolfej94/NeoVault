//
//  ViewTextFileViewTests.swift
//  NeoVault
//
//  Created by James Wolfe on 20/10/2024.
//

import XCTest

@MainActor
final class ViewTextFileViewTests: XCTestCase {

    var app: XCUIApplication!
    var isOnViewTextFileView: Bool { app.navigationBars["Test File"].exists }

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launchArguments.append("UITest")
        app.launch()
        editButton = app.navigationBars["Test File"].buttons["Edit"]
        app.login()
        let financeFolder = app.buttons["Finance"]
        let foldersToLoad = existsExpectation(for: financeFolder)
        wait(for: [foldersToLoad])
        financeFolder.tap()
        let textFile = app.buttons["Test File"]
        textFile.tap()
    }

    override func tearDown() {
        super.setUp()
        app = nil
        editButton = nil
    }

    func testInitialElements() {
        XCTAssertTrue(isOnViewTextFileView)
        XCTAssertTrue(editButton.exists)
    }
}
