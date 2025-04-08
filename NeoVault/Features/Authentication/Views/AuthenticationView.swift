//
//  AuthenticationView.swift
//  NeoVault
//
//  Created by James Wolfe on 09/09/2024.
//

import SwiftUI

struct AuthenticationView: View {

    @State private var viewModel: AuthenticationViewModel

    init(viewModel: AuthenticationViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack {
                Text("_vault")
                    .foregroundStyle(.text)
                    .font(.system(size: 28, weight: .thin))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                emailField
                passwordField
                authButtons
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
        .zIndex(1)
        .frame(height: 60)
    }

    var passwordField: some View {
        VaultSecureTextField(
            secureImage: #imageLiteral(resourceName: "Eye"),
            insecureImage: #imageLiteral(resourceName: "EyeOff"),
            placeholder: "Password",
            disabled: viewModel.state == .loading,
            toggleIsSecure: viewModel.eyeButtonTapped,
            text: $viewModel.password,
            isSecure: $viewModel.securePassword
        )
        .zIndex(1)
        .frame(height: 60)
    }

    var authButtons: some View {
        VStack {
            switch viewModel.state {
            case .loaded:
                HStack {
                    Text("Don't have an account?")
                        .foregroundStyle(.text)
                    Button(
                        action: viewModel.registerButtonTapped,
                        label: {
                            Text("Register")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(Color.blueThree)
                        }
                    )
                    Spacer()
                }
                .transition(.move(edge: .leading))
                .zIndex(-1)
                HStack {
                    Spacer()
                    Button(
                        action: viewModel.loginButtonTapped,
                        label: {
                            Text("Login")
                                .foregroundStyle(Color.white)
                                .frame(width: 140, height: 70)
                                .background {
                                    RoundedRectangle(cornerRadius: 35.0)
                                        .foregroundStyle(Color.blueFour)
                                }
                        }
                    )
                    .disabled(viewModel.loginDisabled)
                    .opacity(viewModel.loginDisabled ? 0.6 : 1)
                }
                .padding(.top, 30)
                .transition(.move(edge: .trailing))
                .zIndex(-1)
            case .loading:
                ProgressView()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .tint(.blueThree)
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
