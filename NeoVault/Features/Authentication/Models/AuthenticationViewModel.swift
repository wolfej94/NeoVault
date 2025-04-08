//
//  AuthenticationViewModel.swift
//  NeoVault
//
//  Created by James Wolfe on 09/09/2024.
//

import Foundation
import SwiftUI

enum AuthenticationAction {
    typealias Handler = (Self) -> Void
    case showRegistry
    case logout(Error)
}

@Observable final class AuthenticationViewModel: ViewModel {

    private let actionHandler: AuthenticationAction.Handler
    private let authenticationCommandFactory: AuthenticationCommandFactory
    private let cryptographyCommandFactory: CryptographyCommandFactory
    var securePassword = true
    var email = ""
    var password = ""

    var loginDisabled: Bool {
        email.isEmpty || email.isValidEmail == false || password.isEmpty
    }

    init(actionHandler: @escaping AuthenticationAction.Handler,
         authenticationCommandFactory: AuthenticationCommandFactory,
         cryptographyCommandFactory: CryptographyCommandFactory
    ) {
        self.actionHandler = actionHandler
        self.authenticationCommandFactory = authenticationCommandFactory
        self.cryptographyCommandFactory = cryptographyCommandFactory
        super.init(state: .loaded)
    }

}

// MARK: - UI Actions
extension AuthenticationViewModel {

    func eyeButtonTapped() {
        withAnimation {
            securePassword.toggle()
        }
    }

    func loginButtonTapped() {
        Task {
            do {
                await setState(to: .loading)
                try await authenticationCommandFactory
                    .loginCommand(email: email, password: password)
                    .execute()
                await syncKeyIfNeeded()
                await setState(to: .loaded)
            } catch {
                await setState(to: .error(message: error.localizedDescription))
            }
        }
    }

    func registerButtonTapped() {
        actionHandler(.showRegistry)
    }

}

// MARK: - Cryptography
extension AuthenticationViewModel {

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
