//
//  XCUIElement+ClearText.swift
//  NeoVault
//
//  Created by James Wolfe on 21/10/2024.
//

import XCTest

extension XCUIElement {

    func clearText() {
        guard let stringValue = value as? String else {
            return
        }
        tap()
        let deleteString = stringValue.map { _ in XCUIKeyboardKey.delete.rawValue }.joined(separator: "")
        typeText(deleteString)
    }
}
