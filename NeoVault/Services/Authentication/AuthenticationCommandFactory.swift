//
//  AuthenticationCommandFactory.swift
//  NeoVault
//
//  Created by James Wolfe on 15/11/2024.
//

protocol AuthenticationCommandFactory {
    func logoutCommand() -> LogoutCommand
    func loginCommand(email: String, password: String) -> LoginCommand
    func registerCommand(email: String, password: String, confirmPassword: String) -> RegisterCommand
    func userNameCommand() -> UserNameCommand
}

struct DefaultAuthenticationCommandFactory: AuthenticationCommandFactory {

    let authenticationService: any AuthenticationService

    init(authenticationService: any AuthenticationService = DefaultAuthenticationService()) {
        self.authenticationService = authenticationService
    }

    func logoutCommand() -> LogoutCommand {
        LogoutCommand(authenticationService: authenticationService)
    }

    func loginCommand(email: String, password: String) -> LoginCommand {
        LoginCommand(email: email, password: password, authenticationService: authenticationService)
    }

    func registerCommand(email: String, password: String, confirmPassword: String) -> RegisterCommand {
        RegisterCommand(
            authenticationService: authenticationService,
            email: email,
            password: password,
            confirmPassword: confirmPassword
        )
    }

    func userNameCommand() -> UserNameCommand {
        UserNameCommand(authenticationService: authenticationService)
    }

}
