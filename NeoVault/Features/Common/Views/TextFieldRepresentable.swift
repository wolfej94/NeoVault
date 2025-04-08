//
//  TextFieldRepresentable.swift
//  NeoVault
//
//  Created by James Wolfe on 24/10/2024.
//

import SwiftUI
import UIKit

struct TextFieldRepresentable: UIViewRepresentable {

    let placeholder: String
    @Binding var text: String
    @Binding var isSecure: Bool
    @Binding var disabled: Bool
    let keyboardType: UIKeyboardType
    let autoCapitalisation: UITextAutocapitalizationType
    let contentType: UITextContentType?
    let isEditing: Bool
    let returnButtonType: UIReturnKeyType
    let returnButtonAction: (() -> Void)?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.isSecureTextEntry = isSecure
        textField.isEnabled = !disabled
        textField.text = text
        textField.placeholder = placeholder
        textField.borderStyle = .none
        textField.textContentType = contentType
        textField.keyboardType = keyboardType
        textField.autocorrectionType = .no
        textField.autocapitalizationType = autoCapitalisation
        textField.addTarget(context.coordinator,
                            action: #selector(Coordinator.textFieldDidChange(_:)),
                            for: .editingChanged)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textField.returnKeyType = returnButtonType
        if isEditing {
            textField.becomeFirstResponder()
        }
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        uiView.isSecureTextEntry = isSecure
        uiView.isEnabled = !disabled
        if isEditing {
            uiView.becomeFirstResponder()
        }
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: TextFieldRepresentable

        init(_ parent: TextFieldRepresentable) {
            self.parent = parent
        }

        @objc func textFieldDidChange(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            parent.returnButtonAction?()
            return true
        }
    }
}
