//
//  RegistrationView.swift
//  NeoVault
//
//  Created by James Wolfe on 09/09/2024.
//

import SwiftUI

struct RegistrationView: View {

    @State private var viewModel: RegistrationViewModel

    init(viewModel: RegistrationViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                Button(
                    action: viewModel.dismissButtonTapped,
                    label: {
                        Image(uiImage: #imageLiteral(resourceName: "Back"))
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.blueThree)
                            .frame(width: 40, height: 40)
                    }
                )
                Text("_register")
                    .foregroundStyle(.text)
                    .font(.system(size: 28, weight: .thin))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                emailField
                passwordField
                confirmPasswordField
                registerButton
                    .padding([.horizontal, .top], 5)
                    .padding(.bottom, 10)
            }
            .padding(.horizontal)
        }
        .toolbar(.hidden)
    }

    var emailField: some View {
        VaultTextField(
            image: #imageLiteral(resourceName: "Mail"),
            placeholder: "Email",
            disabled: viewModel.state == .loading,
            contentType: .emailAddress,
            keyboardType: .emailAddress,
            text: $viewModel.email
        )
        .frame(height: 60)
        .zIndex(1)
    }

    var passwordField: some View {
        VaultSecureTextField(
            secureImage: #imageLiteral(resourceName: "Eye"),
            insecureImage: #imageLiteral(resourceName: "EyeOff"),
            placeholder: "Password",
            disabled: viewModel.state == .loading,
            contentType: .newPassword,
            toggleIsSecure: viewModel.passwordEyeButtonTapped,
            text: $viewModel.password,
            isSecure: $viewModel.securePassword
        )
        .zIndex(1)
    }

    var confirmPasswordField: some View {
        VaultSecureTextField(
            secureImage: #imageLiteral(resourceName: "Eye"),
            insecureImage: #imageLiteral(resourceName: "EyeOff"),
            placeholder: "Confirm Password",
            disabled: viewModel.state == .loading,
            contentType: .newPassword,
            toggleIsSecure: viewModel.confirmPasswordEyeButtonTapped,
            text: $viewModel.confirmPassword,
            isSecure: $viewModel.secureConfirmPassword
        )
        .zIndex(1)
    }

    var registerButton: some View {
        VStack {
            switch viewModel.state {
            case .loaded:
                HStack {
                    Spacer()
                    Button(
                        action: viewModel.registerButtonTapped,
                        label: {
                            Text("Register")
                                .foregroundStyle(Color.white)
                                .frame(width: 140, height: 70)
                                .background {
                                    RoundedRectangle(cornerRadius: 35.0)
                                        .foregroundStyle(Color.blueFour)
                                }
                        }
                    )
                    .disabled(viewModel.registerDisabled)
                    .opacity(viewModel.registerDisabled ? 0.6 : 1)
                }
                .padding(.top, 30)
                .transition(.move(edge: .trailing))
                .zIndex(-1)
            case .loading:
                HStack {
                    Spacer()
                    ProgressView()
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .tint(.blueThree)
                    Spacer()
                }
            case .error(let message):
                Text(message)
                    .accessibilityLabel("Error Label")
                    .font(.caption)
                    .foregroundStyle(Color.red)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }

}
