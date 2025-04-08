//
//  PhotosPickerItem+GenerateName.swift
//  NeoVault
//
//  Created by James Wolfe on 13/11/2024.
//

import SwiftUI
import PhotosUI
import Photos

extension PhotosPickerItem {

    func generateName() -> String {
        if let identifier = itemIdentifier {
            return identifier
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
            let timestamp = dateFormatter.string(from: Date())
            return timestamp
        }
    }

}
