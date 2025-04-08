//
//  URL+Identifiable.swift
//  NeoVault
//
//  Created by James Wolfe on 13/11/2024.
//

import Foundation

extension URL: @retroactive Identifiable {

    public var id: String {
        absoluteString
    }

}
