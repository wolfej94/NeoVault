//
//  String+LastPathComponent.swift
//  StoragePlatform
//
//  Created by James Wolfe on 08/11/2024.
//

import Foundation

internal extension String {
    var lastPathComponent: String {
        (self as NSString).lastPathComponent
    }
}
