//
//  WebView.swift
//  NeoVault
//
//  Created by James Wolfe on 13/11/2024.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {

    private let webView: WKWebView

    init(url: URL) {
        webView = WKWebView(frame: .zero)
        webView.load(.init(url: url))
        webView.isOpaque = false
    }

    func makeUIView(context: Context) -> WKWebView {
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) { }

}
