//
//  FileType.swift
//  NeoVault
//
//  Created by James Wolfe on 11/11/2024.
//

import SwiftUI

enum FileType: String, CaseIterable, Equatable {

    case audio
    case document
    case image
    case video

    init(mimeType: String) {
        switch mimeType {
        case _ where mimeType.hasPrefix("image/"):
            self = .image
        case _ where mimeType.hasPrefix("video/"):
            self = .video
        case _ where mimeType.hasPrefix("audio/"):
            self = .audio
        default:
            self = .document
        }
    }

    var name: String {
        rawValue.capitalized
    }

    var image: Image {
        switch self {
        case .audio:
            return .init(systemName: "music.note")
        case .document:
            return .init(systemName: "doc")
        case .image:
            return .init(systemName: "photo")
        case .video:
            return .init(systemName: "video")
        }
    }

}
