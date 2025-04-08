//
//  AuthenticationTests.swift
//  NeoVault
//
//  Created by James Wolfe on 19/10/2024.
//

import XCTest

@MainActor
final class AuthenticationTests: XCTestCase {

    var app: XCUIApplication!
    var emailTextField: XCUIElement!
    var passwordTextField: XCUIElement!
    var loginButton: XCUIElement!
    var errorLabel: XCUIElement!
    var registryButton: XCUIElement!
    var foldersNavigationBar: XCUIElement!
    var isOnLoginView: Bool { app.navigationBars["Login"].exists }
    var isOnRegistryView: Bool { app.navigationBars["Register"].exists }

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launchArguments.append("UITest")
        app.launch()
        emailTextField = app.textFields["Email"]
        passwordTextField = app.secureTextFields["Password"]
        loginButton = app.buttons["Login"]
        errorLabel = app.staticTexts["Error Label"]
        registryButton = app.buttons["Register"]
        foldersNavigationBar = app.navigationBars["Folders"]
    }

    override func tearDown() {
        super.tearDown()
        app = nil
        emailTextField = nil
        passwordTextField = nil
        loginButton = nil
        registryButton = nil
        foldersNavigationBar = nil
    }

    func testInitialElements() {
        XCTAssertTrue(emailTextField.exists)
        XCTAssertTrue(passwordTextField.exists)
        XCTAssertTrue(loginButton.exists)
        XCTAssertTrue(registryButton.exists)
        XCTAssertTrue(isOnLoginView)
        XCTAssertFalse(errorLabel.exists)
        XCTAssertFalse(isOnRegistryView)
    }

    func testRegistryNavigation() {
        registryButton.tap()
        XCTAssertTrue(isOnRegistryView)
    }

    func testLoginDisabled() {
        XCTAssertFalse(loginButton.isEnabled)
        emailTextField.tap()
        emailTextField.typeText(TestData.InvalidLogin.email)
        XCTAssertFalse(loginButton.isEnabled)
        passwordTextField.tap()
        passwordTextField.typeText(TestData.InvalidLogin.password)
        XCTAssertFalse(loginButton.isEnabled)
        emailTextField.tap()
        emailTextField.typeText(TestData.ValidIncorrectLogin.email)
        XCTAssertTrue(loginButton.isEnabled)
    }

    func testIncorrectLoginError() {
        emailTextField.tap()
        emailTextField.typeText(TestData.ValidIncorrectLogin.email)
        passwordTextField.tap()
        passwordTextField.typeText(TestData.ValidIncorrectLogin.password)
        loginButton.tap()
        let errorLabelToExist = existsExpectation(for: errorLabel)
        wait(for: [errorLabelToExist])
    }

    func testLoginNavigation() {
        app.login()
        let authenticationToHaveCompleted = existsExpectation(for: foldersNavigationBar)
        wait(for: [authenticationToHaveCompleted])
    }

}

extension AuthenticationTests {
    struct TestData {
        struct ValidIncorrectLogin {
            static let email = "test@test.com"
            static let password = "awd"
        }
        struct InvalidLogin {
            static let email = ""
            static let password = "test"
        }
    }
}
