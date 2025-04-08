//
//  PhotosPickerItem+MimeType.swift
//  NeoVault
//
//  Created by James Wolfe on 13/11/2024.
//

import SwiftUI
import PhotosUI
import Photos

extension PhotosPickerItem {

    var mimeType: String? {
        supportedContentTypes.first?.preferredMIMEType
    }

}
