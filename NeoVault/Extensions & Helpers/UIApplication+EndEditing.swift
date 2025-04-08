//
//  UIApplication+EndEditing.swift
//  NeoVault
//
//  Created by James Wolfe on 30/10/2024.
//

import UIKit

extension UIApplication {

    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

}
