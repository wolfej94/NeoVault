//
//  ProfileViewModel.swift
//  NeoVault
//
//  Created by James Wolfe on 21/10/2024.
//

import SwiftUI

@Observable final class ProfileViewModel: ViewModel {

    private let authenticationCommandFactory: AuthenticationCommandFactory

    init(authenticationCommandFactory: AuthenticationCommandFactory) {
        self.authenticationCommandFactory = authenticationCommandFactory
    }

}

// MARK: - Authentication
private extension ProfileViewModel {

    @MainActor
    func logout() async {
        do {
            try await authenticationCommandFactory
                .logoutCommand()
                .execute()
        } catch {
            await setState(to: .error(message: error.localizedDescription))
        }
    }

}

// MARK: - UI Interactions
extension ProfileViewModel {

    func logoutButtonTapped() {
        Task {
            await logout()
        }
    }

}
