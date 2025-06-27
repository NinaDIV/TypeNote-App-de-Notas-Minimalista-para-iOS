//
//  AuthView.swift
//  TypeNote
//
//  Created by Milward on 21/06/25.
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var viewModel: NotesViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var confirmationCode = ""
    @State private var showConfirmation = false
    @State private var pendingEmail = ""
    @State private var isPasswordVisible = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Fondo elegante con gradiente sutil
                BackgroundView()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Espaciado superior dinámico
                        Spacer()
                            .frame(height: max(geometry.size.height * 0.12, 60))
                        
                        // Header principal
                        HeaderSection()
                            .padding(.bottom, 60)
                        
                        // Contenido principal
                        MainContent(
                            email: $email,
                            password: $password,
                            confirmationCode: $confirmationCode,
                            isPasswordVisible: $isPasswordVisible,
                            showConfirmation: showConfirmation,
                            errorMessage: viewModel.errorMessage,
                            isLoading: viewModel.isLoading,
                            isFormValid: isFormValid,
                            onSignIn: signIn,
                            onSignUp: signUp,
                            onConfirm: confirmAccount,
                            onBack: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showConfirmation = false
                                    confirmationCode = ""
                                }
                            }
                        )
                        
                        // Espaciado inferior
                        Spacer()
                            .frame(height: 80)
                    }
                    .padding(.horizontal, 32)
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    // MARK: - Computed Properties
    private var isFormValid: Bool {
        email.isValidEmail && password.isValidPassword
    }
    
    // MARK: - Actions
    private func signIn() {
        Task {
            await viewModel.signIn(email: email, password: password)
        }
    }
    
    private func signUp() {
        Task {
            pendingEmail = email
            await viewModel.signUp(email: email, password: password)
            if viewModel.errorMessage.isEmpty {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showConfirmation = true
                }
            }
        }
    }
    
    private func confirmAccount() {
        Task {
            await viewModel.confirmSignUp(email: pendingEmail, code: confirmationCode)
            if viewModel.errorMessage.isEmpty {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showConfirmation = false
                    confirmationCode = ""
                }
                await viewModel.signIn(email: pendingEmail, password: password)
            }
        }
    }
}

#Preview {
    AuthView()
        .environmentObject(NotesViewModel())
}
