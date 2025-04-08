//
//  LogoutCommand.swift
//  NeoVault
//
//  Created by James Wolfe on 15/11/2024.
//

struct LogoutCommand: AsyncCommand {

    let authenticationService: any AuthenticationService

    func execute() async throws {
        try await authenticationService.unauthenticate()
    }

}
