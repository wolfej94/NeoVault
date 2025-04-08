//
//  AuthenticationService.swift
//  NeoVault
//
//  Created by James Wolfe on 09/09/2024.
//

import Foundation
import FirebaseAuth
import Combine

protocol AuthenticationService: AnyObject, ObservableObject {
    var isAuthenticated: Bool { get }
    func register(email: String, password: String, confirmPassword: String) async throws
    func authenticate(email: String, password: String) async throws
    func unauthenticate() async throws
    func deleteAccount() async throws
    var currentUser: UserInfo? { get }
}

enum AuthenticationError: LocalizedError {
    case passwordMismatch
    case unauthenticated

    var errorDescription: String? {
        switch self {
        case .passwordMismatch:
            return String(localized: "Passwords do not match")
        case .unauthenticated:
            return String(localized: "Unauthenticated")
        }
    }
}

final class DefaultAuthenticationService: AuthenticationService {

    @Published var isAuthenticated: Bool
    private let auth = Auth.auth()
    private var stateChangeListener: AnyObject!

    var currentUser: UserInfo? { auth.currentUser }

    init() {
        isAuthenticated = Auth.auth().currentUser != nil
        stateChangeListener = auth.addStateDidChangeListener { [weak self] _, user in
            self?.isAuthenticated = user != nil
        }
    }

    func unauthenticate() async throws {
        try auth.signOut()
    }

    func deleteAccount() async throws {
        try await auth.currentUser?.delete()
        try auth.signOut()
    }

    func register(email: String, password: String, confirmPassword: String) async throws {
        try await auth.createUser(withEmail: email, password: password)
    }

    func authenticate(email: String, password: String) async throws {
        _ = try await auth.signIn(withEmail: email, password: password)
    }

}
