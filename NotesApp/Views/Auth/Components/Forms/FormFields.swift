//
//  FormFields.swift
//  TypeNote
//
//  Created by Milward on 21/06/25.
//

import SwiftUI

struct FormFields: View {
    @Binding var email: String
    @Binding var password: String
    @Binding var confirmationCode: String
    @Binding var isPasswordVisible: Bool
    let showConfirmation: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            if showConfirmation {
                // Vista de confirmación
                VStack(spacing: 20) {
                    ConfirmationHeader()
                    
                    ModernTextField(
                        icon: "key.fill",
                        title: "Código de Confirmación",
                        text: $confirmationCode,
                        placeholder: "Ingresa el código de 6 dígitos",
                        keyboardType: .numberPad
                    )
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
            } else {
                // Vista de autenticación
                VStack(spacing: 20) {
                    ModernTextField(
                        icon: "envelope.fill",
                        title: "Correo Electrónico",
                        text: $email,
                        placeholder: "tu@email.com",
                        keyboardType: .emailAddress
                    )
                    
                    ModernSecureField(
                        title: "Contraseña",
                        text: $password,
                        placeholder: "Mínimo 8 caracteres",
                        isVisible: $isPasswordVisible
                    )
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .leading).combined(with: .opacity),
                    removal: .move(edge: .trailing).combined(with: .opacity)
                ))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showConfirmation)
    }
}

#Preview {
    VStack(spacing: 40) {
        Text("Vista de Autenticación")
            .font(.headline)
        
        FormFields(
            email: .constant("usuario@email.com"),
            password: .constant(""),
            confirmationCode: .constant(""),
            isPasswordVisible: .constant(true),
            showConfirmation: false
        )
        
        Divider()
        
        Text("Vista de Confirmación")
            .font(.headline)
        
        FormFields(
            email: .constant(""),
            password: .constant(""),
            confirmationCode: .constant("123456"),
            isPasswordVisible: .constant(true),
            showConfirmation: true
        )
    }
    .padding()
}
