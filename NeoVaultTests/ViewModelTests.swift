//
//  ViewModelTests.swift
//  NeoVaultTests
//
//  Created by James Wolfe on 02/08/2024.
//

import Testing
import SwiftUI
@testable import Vault

@Suite("View Model")
struct ViewModelTests {

    @Test("Set state changes state value")
    func setStateChangesStateValue() async {
        let initialState: ViewModel.UIState = .loaded
        let viewModel = ViewModel(state: initialState)
        #expect(viewModel.state == initialState)
        await viewModel.setState(to: .loading)
        #expect(viewModel.state == .loading)
    }

    @Test("Set state error dismisses after delay")
    func setStateErrorDismissesAfterDelay() async throws {
        let viewModel = ViewModel(state: .loaded)
        await viewModel.setState(to: .error(message: ""))
        #expect(viewModel.state == .error(message: ""))
        try await Task.sleep(nanoseconds: 3_100_000_000)
        #expect(viewModel.state == .loaded)
    }

}
