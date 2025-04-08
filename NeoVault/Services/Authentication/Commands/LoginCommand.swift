//
//  LoginCommand.swift
//  NeoVault
//
//  Created by James Wolfe on 15/11/2024.
//

struct LoginCommand: AsyncCommand {

    let email: String
    let password: String
    private let authenticationService: any AuthenticationService

    init(email: String,
         password: String,
         authenticationService: any AuthenticationService
    ) {
        self.email = email
        self.password = password
        self.authenticationService = authenticationService
    }

    func execute() async throws {
        try await authenticationService.authenticate(email: email, password: password)
    }

}
