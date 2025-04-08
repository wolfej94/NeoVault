//
//  ProfileCoordinator.swift
//  NeoVault
//
//  Created by James Wolfe on 21/10/2024.
//

import SwiftUI

enum ProfileCoordinatorAction {
    typealias Handler = (Self) -> Void
    case dismiss
}

struct ProfileCoordinator: View {

    private let actionHandler: ProfileCoordinatorAction.Handler

    init(actionHandler: @escaping ProfileCoordinatorAction.Handler) {
        self.actionHandler = actionHandler
    }

    var body: some View {
        let viewModel = ProfileViewModel(authenticationCommandFactory: DefaultAuthenticationCommandFactory())
        NavigationStack {
            ProfileView(viewModel: viewModel)
        }
    }
}
