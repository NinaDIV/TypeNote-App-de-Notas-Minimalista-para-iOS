//
//  ActionButtonsSection.swift
//  TypeNote
//
//  Created by Milward on 21/06/25.
//

import SwiftUI

struct ActionButtonsSection: View {
    let showConfirmation: Bool
    let isLoading: Bool
    let isFormValid: Bool
    let confirmationCode: String
    let onSignIn: () -> Void
    let onSignUp: () -> Void
    let onConfirm: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            if showConfirmation {
                PremiumButton(
                    title: "Confirmar Cuenta",
                    icon: "checkmark.circle.fill",
                    action: onConfirm,
                    isLoading: isLoading,
                    isDisabled: confirmationCode.isEmpty,
                    style: .primary
                )
                
                PremiumButton(
                    title: "Volver",
                    icon: "arrow.left",
                    action: onBack,
                    style: .tertiary
                )
            } else {
                VStack(spacing: 12) {
                    PremiumButton(
                        title: "Iniciar Sesión",
                        icon: "person.circle.fill",
                        action: onSignIn,
                        isLoading: isLoading,
                        isDisabled: !isFormValid,
                        style: .primary
                    )
                    
                    PremiumButton(
                        title: "Crear Cuenta Nueva",
                        icon: "person.badge.plus",
                        action: onSignUp,
                        isLoading: isLoading,
                        isDisabled: !isFormValid,
                        style: .secondary
                    )
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        Text("Vista de Autenticación")
            .font(.headline)
        
        ActionButtonsSection(
            showConfirmation: false,
            isLoading: false,
            isFormValid: true,
            confirmationCode: "",
            onSignIn: { print("Sign In") },
            onSignUp: { print("Sign Up") },
            onConfirm: { print("Confirm") },
            onBack: { print("Back") }
        )
        
        Divider()
        
        Text("Vista de Confirmación")
            .font(.headline)
        
        ActionButtonsSection(
            showConfirmation: true,
            isLoading: false,
            isFormValid: true,
            confirmationCode: "123456",
            onSignIn: { print("Sign In") },
            onSignUp: { print("Sign Up") },
            onConfirm: { print("Confirm") },
            onBack: { print("Back") }
        )
        
        Divider()
        
        Text("Estado de Carga")
            .font(.headline)
        
        ActionButtonsSection(
            showConfirmation: false,
            isLoading: true,
            isFormValid: true,
            confirmationCode: "",
            onSignIn: { print("Sign In") },
            onSignUp: { print("Sign Up") },
            onConfirm: { print("Confirm") },
            onBack: { print("Back") }
        )
    }
    .padding()
}
