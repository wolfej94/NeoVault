//
//  MockAuthenticationService.swift
//  NeoVaultTests
//
//  Created by James Wolfe on 19/08/2024.
//

import Foundation
import Combine
import FirebaseAuth
@testable import Vault

class MockAuthenticationService: AuthenticationService {

    var currentUser: UserInfo? {
        switch isAuthenticated {
        case true:
            return MockUser()
        case false:
            return nil
        }
    }

    init(isAuthenticated: Bool) {
        self.isAuthenticated = isAuthenticated
    }

    var registryErrorToThrow: Error?
    @MainActor
    func register(email: String, password: String, confirmPassword: String) async throws {
        if let registryErrorToThrow {
            throw registryErrorToThrow
        }
        isAuthenticated = true
    }

    var authenticateErrorToThrow: Error?
    @MainActor
    func authenticate(email: String, password: String) async throws {
        if let authenticateErrorToThrow {
            throw authenticateErrorToThrow
        }
        isAuthenticated = true
    }

    var unauthenticateErrorToThrow: Error?
    func unauthenticate() throws {
        if let unauthenticateErrorToThrow {
            throw unauthenticateErrorToThrow
        }
        isAuthenticated = false
    }

    var wasAccountDeleted = false
    var deleteErrorToThrow: Error?
    func deleteAccount() async throws {
        if let deleteErrorToThrow {
            throw deleteErrorToThrow
        }
        wasAccountDeleted = true
        isAuthenticated = false
    }

    private var onAuthChange: ((Bool) -> Void)?
    @Published var isAuthenticated: Bool {
        didSet {
            onAuthChange?(isAuthenticated)
        }
    }


}
