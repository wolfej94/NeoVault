//
//  NeoVaultTextField.swift
//  NeoVault
//
//  Created by James Wolfe on 24/10/2024.
//

import SwiftUI

struct VaultTextField: View {

    let image: UIImage?
    let placeholder: LocalizedStringResource
    let disabled: Bool
    let autoCapitalisation: UITextAutocapitalizationType
    let contentType: UITextContentType?
    let keyboardType: UIKeyboardType
    let isEditing: Bool
    let returnButtonType: UIReturnKeyType
    let returnButtonAction: (() -> Void)?
    @Binding var text: String

    init(image: UIImage? = nil,
         placeholder: LocalizedStringResource,
         disabled: Bool,
         autoCapitalisation: UITextAutocapitalizationType = .none,
         contentType: UITextContentType? = nil,
         keyboardType: UIKeyboardType,
         isEditing: Bool = false,
         text: Binding<String>,
         returnButtonType: UIReturnKeyType = .default,
         returnButtonAction: (() -> Void)? = nil) {
        self.image = image
        self.placeholder = placeholder
        self.disabled = disabled
        self.autoCapitalisation = autoCapitalisation
        self.contentType = contentType
        self.keyboardType = keyboardType
        self.isEditing = isEditing
        self.returnButtonAction = returnButtonAction
        self.returnButtonType = returnButtonType
        _text = text
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                TextFieldRepresentable(
                    placeholder: String(localized: placeholder),
                    text: $text,
                    isSecure: .constant(false),
                    disabled: .init(
                        get: { disabled },
                        set: { _ in }
                    ),
                    keyboardType: keyboardType,
                    autoCapitalisation: autoCapitalisation,
                    contentType: contentType,
                    isEditing: isEditing,
                    returnButtonType: returnButtonType,
                    returnButtonAction: returnButtonAction
                )
            }
            .padding(.leading, 15)
            .padding(.trailing, image == nil ? 15 : proxy.size.height)
            .tint(.blueTwo)
            .background(Color.field)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.text.opacity(0.5), lineWidth: 1)
            }
            .overlay {
                if let image {
                    HStack {
                        Spacer()
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.blueOne)
                            .frame(width: proxy.size.height / 2)
                    }
                    .padding(.trailing, 15)
                }
            }
            .padding(.all, 1)
        }
    }

}
