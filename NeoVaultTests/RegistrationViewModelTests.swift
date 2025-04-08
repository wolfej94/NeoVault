//
//  RegistrationViewModelTests.swift
//  NeoVaultTests
//
//  Created by James Wolfe on 19/08/2024.
//

import Testing
import UIKit
@testable import Vault

@Suite("Registration View Model")
struct RegistrationViewModelTests {

    let authService: MockAuthenticationService

    init() {
        authService = MockAuthenticationService(isAuthenticated: false)
    }

    @Test("Status is correct depending on registry result",
          arguments: [
            (nil, ViewModel.UIState.loaded),
            (TestData.errors.register, ViewModel.UIState.error(message: TestData.errors.register.localizedDescription))
          ]
    )
    func statusIsCorrect(registryError: Error?, expectedState: ViewModel.UIState) async {
        authService.registryErrorToThrow = registryError
        let subject = RegistrationViewModel(
            actionHandler: { _ in },
            retrieveSaltCommand: { Data() },
            storeSaltCommand: { _, _ in },
            generateKeyCommand: { _, _ in },
            registerCommand: authService.register(email:password:confirmPassword:),
            retrieveExistingKeyCommand: { nil },
            retrieveExistingIVCommand: { nil }
        )
        await subject.register()
        #expect(subject.state == expectedState)
    }

    @Test("Action actionHandler calls correct case when registering",
          arguments: [
            TestData.errors.register,
            nil
          ]
    )
    func didRegisterActionHandler(registryError: Error?) async {
        var didRegisterWasCalled = false
        authService.registryErrorToThrow = registryError
        let subject = RegistrationViewModel(
            actionHandler: { action in
                switch action {
                case .didRegister:
                    didRegisterWasCalled = true
                case .logout, .back:
                    break
                }
            },
            retrieveSaltCommand: { Data() },
            storeSaltCommand: { _, _ in },
            generateKeyCommand: { _, _ in },
            registerCommand: authService.register(email:password:confirmPassword:),
            retrieveExistingKeyCommand: { nil },
            retrieveExistingIVCommand: { nil }
        )
        await subject.register()
        #expect(didRegisterWasCalled == (registryError == nil))
    }

    @Test("Data passed to generate key is correct")
    func testDataPassedToGenerateKeyIsCorrect() async throws {
        let password = "Password"
        let salt = try #require(Data.randomSalt(length: 32))
        var passwordUsedForKey: String?
        var saltUsedForkey: Data?
        let subject = RegistrationViewModel(
            actionHandler: { _ in },
            retrieveSaltCommand: { salt },
            storeSaltCommand: { _, _ in },
            generateKeyCommand: { password, salt in
                passwordUsedForKey = password
                saltUsedForkey = salt
            },
            registerCommand: authService.register(email:password:confirmPassword:),
            retrieveExistingKeyCommand: { nil },
            retrieveExistingIVCommand: { nil }
        )

        subject.email = "test@test.test"
        subject.password = password
        subject.confirmPassword = password
        await subject.register()
        #expect(passwordUsedForKey == password)
        #expect(saltUsedForkey == salt)
    }

    @Test("Throwing from generate key command calls logout")
    func testThrowingFromGenerateKeyCommandCallsLogout() async throws {
        var logoutError: Error?
        let subject = RegistrationViewModel(
            actionHandler: { action in
                switch action {
                case .logout(let error):
                    logoutError = error
                case .didRegister, .back:
                    break
                }
            },
            retrieveSaltCommand: { Data() },
            storeSaltCommand: { _, _ in },
            generateKeyCommand: { _, _ in throw TestData.errors.generateKey },
            registerCommand: authService.register(email:password:confirmPassword:),
            retrieveExistingKeyCommand: { nil },
            retrieveExistingIVCommand: { nil }
        )

        subject.email = "test@test.test"
        subject.password = "Password"
        subject.confirmPassword = "Password"
        await subject.register()
        #expect(logoutError?.localizedDescription == TestData.errors.generateKey.localizedDescription)
    }

    @Test("Generate key is not called if an existing key and iv is passed to the subject")
    func testGenerateKeyIsNotCalledIfAnExistingKeyAndIVIsPassedToTheSubject() async throws {
        let key = Data.randomSalt(length: 32)
        let initialisationVector = Data.randomSalt(length: 32)
        var generatKeyCommandCalled = false
        let subject = RegistrationViewModel(
            actionHandler: { _ in },
            retrieveSaltCommand: { Data() },
            storeSaltCommand: { _, _ in },
            generateKeyCommand: { _, _ in generatKeyCommandCalled = true },
            registerCommand: authService.register(email:password:confirmPassword:),
            retrieveExistingKeyCommand: { key },
            retrieveExistingIVCommand: { initialisationVector }
        )

        subject.email = "test@test.test"
        subject.password = "Password"
        subject.confirmPassword = "Password"
        await subject.register()
        #expect(generatKeyCommandCalled == false)
    }

}

extension RegistrationViewModelTests {
    struct TestData {
        enum errors: LocalizedError {
            case register
            case generateKey

            var errorDescription: String? {
                switch self {
                case .register:
                    "Test"
                case .generateKey:
                    "Generate key"
                }
            }
        }
    }
}
