//
//  UserNameCommand.swift
//  NeoVault
//
//  Created by James Wolfe on 16/11/2024.
//

struct UserNameCommand: Command {

    let authenticationService: any AuthenticationService

    func execute() throws -> String? {
        authenticationService.currentUser?.displayName
    }
}
