//
//  StringExtensionTests.swift
//  NeoVaultTests
//
//  Created by James Wolfe on 25/08/2024.
//

import Testing
@testable import Vault

@Suite("String Extension")
struct StringExtensionTests {

    @Test("String extension for emailIsValid has expected results",
          arguments: [
            ("test@test.test", true),
            ("test@test", false),
          ]
    )
    func isValidEmail(email: String, isValid: Bool) {
        #expect(email.isValidEmail == isValid)
    }
    
}
