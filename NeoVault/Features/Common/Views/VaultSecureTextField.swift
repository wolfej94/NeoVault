//
//  NeoVaultSecureTextField.swift
//  NeoVault
//
//  Created by James Wolfe on 24/10/2024.
//

import SwiftUI

struct VaultSecureTextField: View {

    let secureImage: UIImage
    let insecureImage: UIImage
    let placeholder: LocalizedStringResource
    let disabled: Bool
    let autoCapitalisation: TextInputAutocapitalization?
    let contentType: UITextContentType
    let toggleIsSecure: () -> Void
    let isEditing: Bool
    @Binding var text: String
    @Binding var isSecure: Bool

    init(
        secureImage: UIImage,
        insecureImage: UIImage,
        placeholder: LocalizedStringResource,
        disabled: Bool,
        autoCapitalisation: TextInputAutocapitalization? = .never,
        contentType: UITextContentType = .password,
        toggleIsSecure: @escaping () -> Void,
        isEditing: Bool = false,
        text: Binding<String>,
        isSecure: Binding<Bool>) {
        self.secureImage = secureImage
        self.insecureImage = insecureImage
        self.placeholder = placeholder
        self.disabled = disabled
        self.autoCapitalisation = autoCapitalisation
        self.contentType = contentType
        self.toggleIsSecure = toggleIsSecure
        self.isEditing = isEditing
        _text = text
        _isSecure = isSecure
    }

    var body: some View {
        ZStack {
            TextFieldRepresentable(
                placeholder: String(localized: placeholder),
                text: $text,
                isSecure: $isSecure,
                disabled: .init(
                    get: { disabled },
                    set: { _ in }
                ),
                keyboardType: .default,
                autoCapitalisation: .none,
                contentType: contentType,
                isEditing: isEditing,
                returnButtonType: .default,
                returnButtonAction: nil
            )
        }
        .padding(.leading, 15)
        .padding(.trailing, 60)
        .tint(.blueTwo)
        .frame(height: 60)
        .background(Color.field)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .background {
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.text.opacity(0.5), lineWidth: 1)
        }
        .overlay {
            HStack {
                Spacer()
                Button(
                    action: toggleIsSecure,
                    label: {
                        switch isSecure {
                        case true:
                            Image(uiImage: secureImage)
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.blueOne)
                                .frame(width: 30, height: 30)
                                .transition(
                                    .asymmetric(
                                        insertion: .move(edge: .bottom),
                                        removal: .move(edge: .top).combined(with: .opacity)
                                    )
                                )
                        case false:
                            Image(uiImage: insecureImage)
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.blueOne)
                                .frame(width: 30, height: 30)
                                .transition(
                                    .asymmetric(
                                        insertion: .move(edge: .bottom),
                                        removal: .move(edge: .top).combined(with: .opacity)
                                    )
                                )
                        }

                    }
                )
            }
            .frame(height: 60)
            .clipShape(Rectangle())
            .padding(.trailing, 15)
        }
        .padding(.all, 1)
    }

}
