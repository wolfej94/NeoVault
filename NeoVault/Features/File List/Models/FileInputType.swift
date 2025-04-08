//
//  FileInputType.swift
//  NeoVault
//
//  Created by James Wolfe on 13/11/2024.
//

import SwiftUI
import UniformTypeIdentifiers

enum FileInputType: String, CaseIterable, Equatable {

    case audio
    case document
    case scannedDocument
    case image
    case video

    var utTypes: [UTType] {
        switch self {
        case .audio:
            return [.audio]
        case .document, .scannedDocument:
            return [
                .plainText,
                .rtf,
                .html,
                .xml,
                .pdf,
                UTType(filenameExtension: "doc"),
                UTType(filenameExtension: "docx"),
                .spreadsheet,
                .presentation,
                .archive,
                .sourceCode,
                .text,
                .data,
                .json
            ]
                .compactMap({ $0 })
        case .image:
            return [UTType.image]
        case .video:
            return [UTType.video]
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
        case .scannedDocument:
            return .init(systemName: "document.viewfinder")
        case .image:
            return .init(systemName: "photo")
        case .video:
            return .init(systemName: "video")
        }
    }

}
