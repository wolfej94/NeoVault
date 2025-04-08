//
//  ProfileView.swift
//  NeoVault
//
//  Created by James Wolfe on 21/10/2024.
//

import SwiftUI

struct ProfileView: View {

    @State private var viewModel: ProfileViewModel

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            Button(
                action: viewModel.logoutButtonTapped,
                label: { Text("Logout").foregroundStyle(Color.text) }
            )
        }
        .navigationTitle("Profile")
    }
}
