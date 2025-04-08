//
//  ViewFileView.swift
//  NeoVault
//
//  Created by James Wolfe on 13/11/2024.
//

import SwiftUI

struct ViewFileView: View {

    @State private var viewModel: ViewFileViewModel

    init(viewModel: ViewFileViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 20) {
            HStack {
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
                Spacer()
                Button(
                    action: viewModel.shareButtonTapped,
                    label: {
                        Image(uiImage: #imageLiteral(resourceName: "Share"))
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.blueThree)
                            .frame(width: 40, height: 40)
                    }
                )
            }
            Text(viewModel.file.name)
                .foregroundStyle(.text)
                .font(.system(size: 28, weight: .thin))
                .frame(maxWidth: .infinity, alignment: .leading)
            if let url = viewModel.file.url {
                WebView(url: url)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10).stroke(Color.text, lineWidth: 1)
                    }
            }
        }
        .navigationBarHidden(true)
        .padding()
    }

}
