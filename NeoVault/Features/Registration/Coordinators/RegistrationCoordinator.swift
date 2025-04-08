//
//  RegistrationCoordinator.swift
//  NeoVault
//
//  Created by James Wolfe on 09/09/2024.
//

import Foundation
import SwiftUI

enum RegistrationCoordinatorAction {
    typealias Handler = (Self) -> Void
    case dismiss
    case logout(Error)
}

struct RegistrationCoordinator: View {

    private let authenticationCommandFactory: AuthenticationCommandFactory
    private let cryptographyCommandFactory: CryptographyCommandFactory
    private let actionHandler: RegistrationCoordinatorAction.Handler

    init(authenticationCommandFactory: AuthenticationCommandFactory = DefaultAuthenticationCommandFactory(),
         cryptographyCommandFactory: CryptographyCommandFactory = DefaultCryptographyCommandFactory(),
         actionHandler: @escaping RegistrationCoordinatorAction.Handler) {
        self.authenticationCommandFactory = authenticationCommandFactory
        self.cryptographyCommandFactory = cryptographyCommandFactory
        self.actionHandler = actionHandler
    }

    var body: some View {
        let viewModel = RegistrationViewModel(
            actionHandler: handleRegistrationAction(_:),
            cryptographyCommandFactory: cryptographyCommandFactory,
            authenticationCommandFactory: authenticationCommandFactory
        )
        RegistrationView(viewModel: viewModel)
    }

    private func handleRegistrationAction(_ action: RegistrationAction) {
        switch action {
        case .dismiss:
            actionHandler(.dismiss)
        case .logout(let error):
            actionHandler(.logout(error))
        }
    }

}
