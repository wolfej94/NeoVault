//
//  String+DeletingPathExtension.swift
//  StoragePlatform
//
//  Created by James Wolfe on 08/11/2024.
//

import Foundation

internal extension String {
    var deletingPathExtension: String {
        (self as NSString).deletingPathExtension
    }
}
