//
//  RootCoordinator.swift
//  NeoVault
//
//  Created by James Wolfe on 09/09/2024.
//

import Foundation
import SwiftUI

struct RootCoordinator<AuthService: AuthenticationService>: View {

    @State var logoutError: Error?
    @StateObject private var authService: AuthService

    init(authService: AuthService = DefaultAuthenticationService()) {
        _authService = .init(wrappedValue: authService)
    }

    var body: some View {
        ZStack {
            switch authService.isAuthenticated {
            case true:
                NavigationStack {
                    FolderListCoordinator()
                }
            case false:
                NavigationStack {
                    AuthenticationCoordinator(actionHandler: handleAuthenticationAction(_:))
                }
            }
        }
        .alert(
            "Something went wrong",
            isPresented: .init(get: { logoutError != nil }, set: { if !$0 { logoutError = nil } }),
            actions: {
                Button(role: .cancel, action: handleAlertDismissAction, label: { Text("Dismiss") })
            },
            message: { Text(logoutError?.localizedDescription ?? "") }
        )
        .onChange(of: authService.isAuthenticated) { _, newValue in
            if newValue {
                Task {
                    try await DefaultStorageService.shared.fetchFolders(sync: true)
                }
            }
        }
    }

    private func handleAuthenticationAction(_ action: AuthenticationCoordinatorAction) {
        switch action {
        case .logout(let error):
            logoutError = error
        }
    }

    private func handleAlertDismissAction() {
        Task {
            try? await authService.unauthenticate()
        }
    }

}

#Preview {
    RootCoordinator(authService: DefaultAuthenticationService())
}
