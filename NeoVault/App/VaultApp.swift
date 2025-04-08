//
//  NeoVaultApp.swift
//  NeoVault
//
//  Created by James Wolfe on 02/10/2024.
//

import SwiftUI
import Firebase
import SwiftData

@main
struct VaultApp: App {

    private let authenticationCommandFactory: AuthenticationCommandFactory

    init() {
        FirebaseApp.configure()
        authenticationCommandFactory = DefaultAuthenticationCommandFactory()
    }

    var body: some Scene {
        WindowGroup {
            RootCoordinator()
                .task {
                    let logoutOnLaunch = ProcessInfo.processInfo.arguments.contains("logout_on_launch")
                    UserDefaults.standard.set(logoutOnLaunch, forKey: "logout_on_launch")
                    if logoutOnLaunch {
                        try? await authenticationCommandFactory.logoutCommand().execute()
                    }
                }
        }
    }
}
