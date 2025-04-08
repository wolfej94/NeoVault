//
//  RegisterCommand.swift
//  NeoVault
//
//  Created by James Wolfe on 15/11/2024.
//

struct RegisterCommand: AsyncCommand {

    let authenticationService: any AuthenticationService
    let email: String
    let password: String
    let confirmPassword: String

    func execute() async throws {
        try await authenticationService.register(email: email, password: password, confirmPassword: confirmPassword)
    }
}
