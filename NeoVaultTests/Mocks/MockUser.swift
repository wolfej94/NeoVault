//
//  MockUser.swift
//  NeoVault
//
//  Created by James Wolfe on 17/10/2024.
//

import FirebaseAuth

class MockUser: NSObject, UserInfo {
    var providerID: String = ""
    var uid: String = ""
    var displayName: String? = ""
    var photoURL: URL? = nil
    var email: String? = ""
    var phoneNumber: String? = ""
}
