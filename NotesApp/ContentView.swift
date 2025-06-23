//
//  ContentView.swift
//  NotesApp
//
//  Created by Milward on 22/06/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = NotesViewModel()
    @State private var showingError = false
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            Group {
                if viewModel.isSignedIn {
                    MainView(navigationPath: $navigationPath)
                        .environmentObject(viewModel)
                } else {
                    AuthView()
                        .environmentObject(viewModel)
                }
            }
        }
        .task {
            await viewModel.checkAuthStatus()
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK") {
                viewModel.clearError()
            }
        } message: {
            Text(viewModel.errorMessage)
        }
        .onChange(of: viewModel.errorMessage) { newValue in
            showingError = !newValue.isEmpty
        }
    }
}
