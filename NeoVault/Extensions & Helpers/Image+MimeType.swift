//
//  UIImage+MimeType.swift
//  NeoVault
//
//  Created by James Wolfe on 23/10/2024.
//

import SwiftUI

extension Image {

    init(mimeType: String) {
        switch mimeType {
        case _ where mimeType.hasPrefix("image/"):
            self.init(systemName: "photo")
        case _ where mimeType.hasPrefix("video/"):
            self.init(systemName: "video")
        case _ where mimeType.hasPrefix("audio/"):
            self.init(systemName: "music.note")
        default:
            self.init(systemName: "doc.text")
        }
    }

}
