//
//  XCUIApplication+Login.swift
//  NeoVault
//
//  Created by James Wolfe on 20/10/2024.
//

import XCTest

extension XCUIApplication {
    func login() {
        let email = "james.wolfe94@outlook.com"
        let password = "Secret123."
        let emailTextField = textFields["Email"]
        let passwordTextField = secureTextFields["Password"]
        let loginButton = buttons["Login"]
        emailTextField.tap()
        emailTextField.typeText(email)
        passwordTextField.tap()
        passwordTextField.typeText(password)
        loginButton.tap()
    }
}
