//
//  AuthenticationCoordinator.swift
//  NeoVault
//
//  Created by James Wolfe on 09/09/2024.
//

import SwiftUI

enum AuthenticationCoordinatorAction {
    typealias Handler = (Self) -> Void
    case logout(Error)
}

struct AuthenticationCoordinator: View {

    @State var showRegistry = false
    private let actionHandler: AuthenticationCoordinatorAction.Handler
    let cryptographyCommandFactory: CryptographyCommandFactory
    let authenticationCommandFactory: AuthenticationCommandFactory

    init(authenticationCommandFactory: AuthenticationCommandFactory = DefaultAuthenticationCommandFactory(),
         cryptographyCommandFactory: CryptographyCommandFactory = DefaultCryptographyCommandFactory(),
         actionHandler: @escaping AuthenticationCoordinatorAction.Handler) {
        self.authenticationCommandFactory = authenticationCommandFactory
        self.cryptographyCommandFactory = cryptographyCommandFactory
        self.actionHandler = actionHandler
    }

    var body: some View {
        let viewModel = AuthenticationViewModel(
            actionHandler: handleAuthAction(_:),
            authenticationCommandFactory: authenticationCommandFactory,
            cryptographyCommandFactory: cryptographyCommandFactory
        )
        AuthenticationView(viewModel: viewModel)
            .navigationDestination(
                isPresented: $showRegistry,
                destination: {
                    RegistrationCoordinator(actionHandler: handleRegistryAction)
                }
            )
    }

}

// MARK: - Action Handlers
extension AuthenticationCoordinator {

    private func handleAuthAction(_ action: AuthenticationAction) {
        switch action {
        case .showRegistry:
            showRegistry = true
        case .logout(let error):
            actionHandler(.logout(error))
        }
    }

    private func handleRegistryAction(_ action: RegistrationCoordinatorAction) {
        switch action {
        case .logout(let error):
            actionHandler(.logout(error))
        case .dismiss:
            showRegistry = false
        }
    }

}
