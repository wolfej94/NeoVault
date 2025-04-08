//
//  XCTestCase+ExistsExpectation.swift
//  NeoVault
//
//  Created by James Wolfe on 19/10/2024.
//

import XCTest

extension XCTestCase {
    func existsExpectation(for element: XCUIElement) -> XCTestExpectation {
        let existsPredicate = NSPredicate(format: "exists == true")
        return expectation(for: existsPredicate, evaluatedWith: element)
    }

    func enabledExpectation(for element: XCUIElement) -> XCTestExpectation {
        let existsPredicate = NSPredicate(format: "isEnabled == true")
        return expectation(for: existsPredicate, evaluatedWith: element)
    }
}
