//
//  String+Email.swift
//  NeoVault
//
//  Created by James Wolfe on 09/09/2024.
//

import Foundation

extension String {

    var isValidEmail: Bool {
        let emailRegEx = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: self)
    }

}
