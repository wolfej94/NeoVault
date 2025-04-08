//
//  AuthViewModelTests.swift
//  NeoVaultTests
//
//  Created by James Wolfe on 19/08/2024.
//

import Testing
import UIKit
@testable import Vault

@Suite("Auth View Model")
struct AuthViewModelTests {

    let authService: MockAuthenticationService

    init() {
        authService = MockAuthenticationService(isAuthenticated: false)
    }

    @Test("State is correct depending on auth result",
          arguments: [
            (nil, ViewModel.UIState.loaded),
            (TestData.errors.auth, ViewModel.UIState.error(message: TestData.errors.auth.localizedDescription))
          ]
    )
    func statusIsCorrect(authError: Error?, expectedState: ViewModel.UIState) async {
        authService.authenticateErrorToThrow = authError
        let subject = AuthenticationViewModel(
            actionHandler: { _ in },
            loginCommand: authService.authenticate(email:password:),
            retrieveSaltCommand: { Data() },
            storeSaltCommand: { _, _ in },
            generateKeyCommand: { _, _ in },
            retrieveExistingKeyCommand: { nil },
            retrieveExistingIVCommand: { nil }
        )
        await subject.login()
        #expect(subject.state == expectedState)
    }

    @Test("Action actionHandler calls correct case when logging in",
          arguments: [
            TestData.errors.auth,
            nil
        ]
    )
    func didLoginActionHandler(authError: Error?) async {
        var didLoginWasCalled = false
        authService.authenticateErrorToThrow = authError
        let subject = AuthenticationViewModel(
            actionHandler: { action in
                switch action {
                case .didLogin:
                    didLoginWasCalled = true
                case .showRegistry, .logout:
                    break
                }
            },
            loginCommand: authService.authenticate(email:password:),
            retrieveSaltCommand: { Data() },
            storeSaltCommand: { _, _ in },
            generateKeyCommand: { _, _ in },
            retrieveExistingKeyCommand: { nil },
            retrieveExistingIVCommand: { nil }
        )
        await subject.login()
        #expect(didLoginWasCalled == (authError == nil))
    }

    @Test("Action actionHandler calls correct case when trying to show registry",
          arguments: [
            true,
            false
          ]
    )
    func registryActionHandler(shouldShowRegistry: Bool) {
        var didShowRegistry = false
        let subject = AuthenticationViewModel(
            actionHandler: { action in
                switch action {
                case .didLogin, .logout:
                    break
                case .showRegistry:
                    didShowRegistry = true
                }
            },
            loginCommand: authService.authenticate(email:password:),
            retrieveSaltCommand: { Data() },
            storeSaltCommand: { _, _ in },
            generateKeyCommand: { _, _ in },
            retrieveExistingKeyCommand: { nil },
            retrieveExistingIVCommand: { nil }
        )
        if shouldShowRegistry {
            subject.register()
        }
        #expect(didShowRegistry == shouldShowRegistry)
    }

    @Test("Data passed to generate key is correct")
    func testDataPassedToGenerateKeyIsCorrect() async throws {
        let password = "Password"
        let salt = try #require(Data.randomSalt(length: 32))
        var passwordUsedForKey: String?
        var saltUsedForkey: Data?
        let subject = AuthenticationViewModel(
            actionHandler: { _ in },
            loginCommand: { _, _ in },
            retrieveSaltCommand: { salt },
            storeSaltCommand: { _, _ in },
            generateKeyCommand: { password, salt in
                passwordUsedForKey = password
                saltUsedForkey = salt
            },
            retrieveExistingKeyCommand: { nil },
            retrieveExistingIVCommand: { nil }
        )

        subject.email = "test@test.test"
        subject.password = password
        await subject.login()
        #expect(passwordUsedForKey == password)
        #expect(saltUsedForkey == salt)
    }

    @Test("Throwing from generate key command calls logout")
    func testThrowingFromGenerateKeyCommandCallsLogout() async throws {
        var logoutError: Error?
        let subject = AuthenticationViewModel(
            actionHandler: { action in
                switch action {
                case .logout(let error):
                    logoutError = error
                case .didLogin, .showRegistry:
                    break
                }
            },
            loginCommand: { _, _ in },
            retrieveSaltCommand: { Data() },
            storeSaltCommand: { _, _ in },
            generateKeyCommand: { _, _ in
                throw TestData.errors.generateKey
            },
            retrieveExistingKeyCommand: { nil },
            retrieveExistingIVCommand: { nil }
        )

        subject.email = "test@test.test"
        subject.password = "Password"
        await subject.login()
        #expect(logoutError?.localizedDescription == TestData.errors.generateKey.localizedDescription)
    }

    @Test("Generate key is not called if an existing key and iv is passed to the subject")
    func testGenerateKeyIsNotCalledIfAnExistingKeyAndIVIsPassedToTheSubject() async throws {
        let key = Data.randomSalt(length: 32)
        let initialisationVector = Data.randomSalt(length: 32)
        var generatKeyCommandCalled = false
        let subject = AuthenticationViewModel(
            actionHandler: { _ in },
            loginCommand: { _, _ in },
            retrieveSaltCommand: { Data() },
            storeSaltCommand: { _, _ in },
            generateKeyCommand: { _, _ in generatKeyCommandCalled = true },
            retrieveExistingKeyCommand: { key },
            retrieveExistingIVCommand: { initialisationVector }
        )

        subject.email = "test@test.test"
        subject.password = "Password"
        await subject.login()
        #expect(generatKeyCommandCalled == false)
    }
}

extension AuthViewModelTests {
    struct TestData {
        enum errors: LocalizedError {
            case auth
            case generateKey

            var errorDescription: String? {
                switch self {
                case .auth:
                    "Test"
                case .generateKey:
                    "Generate key"
                }
            }
        }
    }
}
