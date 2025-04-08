//
//  FolderListTests.swift
//  NeoVault
//
//  Created by James Wolfe on 20/10/2024.
//

import XCTest

@MainActor
final class TabBarTests: XCTestCase {

    var app: XCUIApplication!
    var tabBar: XCUIElement!
    var foldersTabBarItem: XCUIElement!
    var settingsTabBarItem: XCUIElement!
    var isOnFoldersView: Bool { app.navigationBars["Folders"].exists }
    var isOnProfileView: Bool { app.navigationBars["Profile"].exists }

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launchArguments.append("UITest")
        app.launch()
        foldersTabBarItem = app.tabBars.firstMatch.buttons["Library"]
        settingsTabBarItem = app.tabBars.firstMatch.buttons["Profile"]
        tabBar = app.tabBars.firstMatch
        app.login()
        let loginIsCompleted = existsExpectation(for: app.navigationBars["Folders"])
        wait(for: [loginIsCompleted])
    }

    override func tearDown() {
        super.tearDown()
        app = nil
        foldersTabBarItem = nil
        settingsTabBarItem = nil
    }

    func testInitialElements() {
        XCTAssertTrue(tabBar.exists)
        XCTAssertTrue(foldersTabBarItem.exists)
        XCTAssertTrue(settingsTabBarItem.exists)
    }

    func InitialTabIsFolders() {
        XCTAssertTrue(isOnFoldersView)
    }

    func testTabNavigation() {
        settingsTabBarItem.tap()
        XCTAssertTrue(isOnProfileView)
        foldersTabBarItem.tap()
        XCTAssertTrue(isOnFoldersView)
    }

}
