//
//  ShareSheet.swift
//  NeoVault
//
//  Created by James Wolfe on 13/11/2024.
//

import SwiftUI
import UIKit

struct ShareSheet: UIViewControllerRepresentable {

    var items: [Any]
    var excludedActivityTypes: [UIActivity.ActivityType]?

    init(items: [Any], excludedActivityTypes: [UIActivity.ActivityType]? = nil) {
        self.items = items
        self.excludedActivityTypes = excludedActivityTypes
    }

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if let excludedTypes = excludedActivityTypes {
            activityVC.excludedActivityTypes = excludedTypes
        }
        return activityVC
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) { }

}
