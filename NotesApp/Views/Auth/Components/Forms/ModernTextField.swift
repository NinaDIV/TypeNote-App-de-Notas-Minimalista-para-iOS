//
//  ModernTextField.swift
//  TypeNote
//
//  Created by Milward on 21/06/25.
//

import SwiftUI

struct ModernTextField: View {
    let icon: String
    let title: String
    @Binding var text: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    var isDisabled: Bool = false
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(isFocused ? .blue : .secondary)
                    .frame(width: 16)
                    .animation(.easeInOut(duration: 0.2), value: isFocused)
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isFocused ? .blue : .secondary)
                    .animation(.easeInOut(duration: 0.2), value: isFocused)
                
                Spacer()
            }
            
            TextField(placeholder, text: $text)
                .font(.system(size: 16, weight: .regular))
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray6).opacity(0.6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    isFocused ? Color.blue.opacity(0.6) : Color.clear,
                                    lineWidth: 2
                                )
                        )
                )
                .focused($isFocused)
                .autocapitalization(.none)
                .keyboardType(keyboardType)
                .disabled(isDisabled)
                .opacity(isDisabled ? 0.6 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isFocused)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        ModernTextField(
            icon: "envelope.fill",
            title: "Correo Electrónico",
            text: .constant(""),
            placeholder: "tu@email.com",
            keyboardType: .emailAddress
        )
        
        ModernTextField(
            icon: "key.fill",
            title: "Código de Confirmación",
            text: .constant("123456"),
            placeholder: "Ingresa el código de 6 dígitos",
            keyboardType: .numberPad
        )
        
        ModernTextField(
            icon: "person.fill",
            title: "Campo Deshabilitado",
            text: .constant("No editable"),
            placeholder: "Placeholder",
            isDisabled: true
        )
    }
    .padding()
}
