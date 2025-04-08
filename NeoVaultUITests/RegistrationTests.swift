//
//  RegistrationTests.swift
//  NeoVault
//
//  Created by James Wolfe on 20/10/2024.
//

import XCTest

@MainActor
final class RegistrationTests: XCTestCase {

    var app: XCUIApplication!
    var emailTextField: XCUIElement!
    var passwordTextField: XCUIElement!
    var confirmPasswordTextField: XCUIElement!
    var registerButton: XCUIElement!
    var isOnFoldersView: Bool { app.navigationBars["Folders"].exists }
    var isOnRegistryView: Bool { app.navigationBars["Register"].exists }

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launchArguments.append("UITest")
        app.launch()
        emailTextField = app.textFields["Email"]
        passwordTextField = app.secureTextFields["Password"]
        confirmPasswordTextField = app.secureTextFields["Confirm Password"]
        registerButton = app.buttons["Register"].firstMatch
        registerButton.tap()
        let setupToFinish = existsExpectation(for: confirmPasswordTextField)
        wait(for: [setupToFinish])
    }

    override func tearDown() {
        super.tearDown()
        app = nil
        emailTextField = nil
        passwordTextField = nil
        confirmPasswordTextField = nil
        registerButton = nil
    }

    func testInitialElements() {
        XCTAssertTrue(emailTextField.exists)
        XCTAssertTrue(confirmPasswordTextField.exists)
        XCTAssertTrue(passwordTextField.exists)
        XCTAssertTrue(registerButton.exists)
        XCTAssertTrue(isOnRegistryView)
        XCTAssertFalse(isOnFoldersView)
    }

    func testRegisterDisabled() {
        XCTAssertFalse(registerButton.isEnabled)
        emailTextField.tap()
        emailTextField.typeText(TestData.InvalidDetails.email)
        XCTAssertFalse(registerButton.isEnabled)
        passwordTextField.tap()
        passwordTextField.typeText(TestData.InvalidDetails.password)
        XCTAssertFalse(registerButton.isEnabled)
        confirmPasswordTextField.tap()
        confirmPasswordTextField.typeText(String(TestData.InvalidDetails.password.reversed()))
        XCTAssertFalse(registerButton.isEnabled)
        confirmPasswordTextField.tap()
        confirmPasswordTextField.typeText(String(TestData.ValidDetails.password))
        emailTextField.tap()
        emailTextField.typeText(TestData.ValidDetails.email)
        XCTAssertTrue(registerButton.isEnabled)
    }

}

extension RegistrationTests {
    struct TestData {
        struct ValidDetails {
            static let email = "test@test.com"
            static let password = "awd"
        }
        struct InvalidDetails {
            static let email = ""
            static let password = "test"
        }
    }
}
