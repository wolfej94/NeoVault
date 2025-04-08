//
//  RegistrationViewModel.swift
//  NeoVault
//
//  Created by James Wolfe on 09/09/2024.
//

import Foundation
import SwiftUI

enum RegistrationAction {
    typealias Handler = (Self) -> Void
    case dismiss
    case logout(Error)
}

@Observable final class RegistrationViewModel: ViewModel {

    private let actionHandler: RegistrationAction.Handler
    private let cryptographyCommandFactory: CryptographyCommandFactory
    private let authenticationCommandFactory: AuthenticationCommandFactory
    var securePassword = true
    var secureConfirmPassword = true
    var email = ""
    var password = ""
    var confirmPassword = ""

    var registerDisabled: Bool {
        email.isEmpty ||
        email.isValidEmail == false ||
        password.isEmpty ||
        confirmPassword.isEmpty
    }

    init(actionHandler: @escaping RegistrationAction.Handler,
         cryptographyCommandFactory: CryptographyCommandFactory,
         authenticationCommandFactory: AuthenticationCommandFactory) {
        self.actionHandler = actionHandler
        self.authenticationCommandFactory = authenticationCommandFactory
        self.cryptographyCommandFactory = cryptographyCommandFactory
        super.init(state: .loaded)
    }

}

// MARK: - UI Actions
extension RegistrationViewModel {

    func dismissButtonTapped() {
        actionHandler(.dismiss)
    }

    func passwordEyeButtonTapped() {
        withAnimation {
            securePassword.toggle()
        }
    }

    func confirmPasswordEyeButtonTapped() {
        withAnimation {
            secureConfirmPassword.toggle()
        }
    }

    func registerButtonTapped() {
        Task {
            await register()
        }
    }

}

// MARK: - Authentication
private extension RegistrationViewModel {

    @MainActor
    private func register() async {
        do {
            await setState(to: .loading)
            try await authenticationCommandFactory
                .registerCommand(
                    email: email,
                    password: password,
                    confirmPassword: confirmPassword
                ).execute()
            await syncKeyIfNeeded()
            await setState(to: .loaded)
        } catch {
            await setState(to: .error(message: error.localizedDescription))
        }
    }

}

// MARK: - Cryptography
private extension RegistrationViewModel {

    @MainActor
    private func syncKeyIfNeeded() async {
        let key = try? cryptographyCommandFactory
            .retrieveExistingKeyCommand()
            .execute()
        let initialisationVector = try? cryptographyCommandFactory
            .retrieveExistingIVCommand()
            .execute()
        guard key == nil || initialisationVector == nil else { return }
        do {
            let salt = try await cryptographyCommandFactory
                .getSaltCommand()
                .execute()
            try await cryptographyCommandFactory
                .storeSaltCommand(salt: salt, onProgress: nil)
                .execute()
            _ = try cryptographyCommandFactory
                .generateKeyCommand(salt: salt, password: password)
                .execute()
        } catch {
            actionHandler(.logout(error))
        }
    }

}
