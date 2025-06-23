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
    @State private var isSecureFieldVisible = true
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    // Header Section
                    VStack(spacing: 24) {
                        Spacer(minLength: geometry.size.height * 0.1)
                        
                        // App Icon & Title
                        VStack(spacing: 16) {
                            // Elegant App Icon
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.05)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 80, height: 80)
                                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                                
                                Text("T")
                                    .font(.system(size: 36, weight: .medium, design: .serif))
                                    .foregroundColor(.primary)
                            }
                            
                            VStack(spacing: 8) {
                                Text("TypeNote")
                                    .font(.system(size: 32, weight: .light, design: .default))
                                    .foregroundColor(.primary)
                                
                                Text("Escribe. Organiza. Inspírate.")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        
                        Spacer(minLength: 40)
                    }
                    
                    // Form Section
                    VStack(spacing: 24) {
                        // Error Message
                        if !viewModel.errorMessage.isEmpty {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.orange)
                                Text(viewModel.errorMessage)
                                    .font(.caption)
                                    .foregroundColor(.orange)
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(12)
                        }
                        
                        // Form Fields
                        VStack(spacing: 20) {
                            // Email Field
                            CustomTextField(
                                title: "Email",
                                text: $email,
                                placeholder: "tu@email.com",
                                keyboardType: .emailAddress,
                                isDisabled: showConfirmation
                            )
                            
                            // Password Field (only when not in confirmation)
                            if !showConfirmation {
                                CustomSecureField(
                                    title: "Contraseña",
                                    text: $password,
                                    placeholder: "Mínimo 8 caracteres",
                                    isVisible: $isSecureFieldVisible
                                )
                            }
                            
                            // Confirmation Code Field
                            if showConfirmation {
                                CustomTextField(
                                    title: "Código de Confirmación",
                                    text: $confirmationCode,
                                    placeholder: "123456",
                                    keyboardType: .numberPad
                                )
                                
                                VStack(spacing: 8) {
                                    HStack {
                                        Image(systemName: "envelope.fill")
                                            .foregroundColor(.blue)
                                        Text("Código enviado a tu email")
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                        Spacer()
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                        
                        // Action Buttons
                        VStack(spacing: 16) {
                            if showConfirmation {
                                // Confirmation Flow
                                CustomButton(
                                    title: "Confirmar Cuenta",
                                    action: confirmAccount,
                                    isLoading: viewModel.isLoading,
                                    isDisabled: confirmationCode.isEmpty,
                                    style: .primary
                                )
                                
                                CustomButton(
                                    title: "← Volver",
                                    action: {
                                        showConfirmation = false
                                        confirmationCode = ""
                                    },
                                    style: .secondary
                                )
                                
                            } else {
                                // Authentication Flow
                                CustomButton(
                                    title: "Iniciar Sesión",
                                    action: signIn,
                                    isLoading: viewModel.isLoading,
                                    isDisabled: !isFormValid,
                                    style: .primary
                                )
                                
                                CustomButton(
                                    title: "Crear Cuenta Nueva",
                                    action: signUp,
                                    isLoading: viewModel.isLoading,
                                    isDisabled: !isFormValid,
                                    style: .accent
                                )
                            }
                        }
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
        .background(
            LinearGradient(
                colors: [
                    Color(.systemGroupedBackground),
                    Color(.systemBackground)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    // MARK: - Computed Properties
    private var isFormValid: Bool {
        !email.isEmpty &&
        email.contains("@") &&
        !password.isEmpty &&
        password.count >= 8
    }
    
    // MARK: - Methods
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
                showConfirmation = true
            }
        }
    }
    
    private func confirmAccount() {
        Task {
            await viewModel.confirmSignUp(email: pendingEmail, code: confirmationCode)
            
            if viewModel.errorMessage.isEmpty {
                showConfirmation = false
                confirmationCode = ""
                
                await viewModel.signIn(email: pendingEmail, password: password)
            }
        }
    }
}

// MARK: - Custom Components

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    var isDisabled: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
            
            TextField(placeholder, text: $text)
                .font(.system(size: 16))
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(text.isEmpty ? Color.clear : Color.blue.opacity(0.3), lineWidth: 1)
                )
                .autocapitalization(.none)
                .keyboardType(keyboardType)
                .disabled(isDisabled)
                .opacity(isDisabled ? 0.6 : 1.0)
        }
    }
}

struct CustomSecureField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    @Binding var isVisible: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
            
            HStack {
                if isVisible {
                    SecureField(placeholder, text: $text)
                        .font(.system(size: 16))
                } else {
                    TextField(placeholder, text: $text)
                        .font(.system(size: 16))
                }
                
                Button(action: { isVisible.toggle() }) {
                    Image(systemName: isVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.secondary)
                        .font(.system(size: 16))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(text.isEmpty ? Color.clear : Color.blue.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

struct CustomButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    var isDisabled: Bool = false
    let style: ButtonStyle
    
    enum ButtonStyle {
        case primary, secondary, accent
        
        var backgroundColor: Color {
            switch self {
            case .primary: return .blue
            case .secondary: return Color(.secondarySystemGroupedBackground)
            case .accent: return .green
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .primary, .accent: return .white
            case .secondary: return .primary
            }
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.9)
                        .tint(style.foregroundColor)
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(style.foregroundColor)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(style.backgroundColor)
                    .opacity(isDisabled ? 0.6 : 1.0)
            )
        }
        .disabled(isDisabled || isLoading)
        .scaleEffect(isDisabled ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isDisabled)
    }
}

#Preview {
    AuthView()
        .environmentObject(NotesViewModel())
}
