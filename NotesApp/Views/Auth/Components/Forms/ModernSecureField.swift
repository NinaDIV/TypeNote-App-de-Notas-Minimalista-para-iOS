//
//  ModernSecureField.swift
//  TypeNote
//
//  Created by Milward on 21/06/25.
//

import SwiftUI

struct ModernSecureField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    @Binding var isVisible: Bool
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lock.fill")
                    .foregroundColor(isFocused ? .blue : .secondary)
                    .frame(width: 16)
                    .animation(.easeInOut(duration: 0.2), value: isFocused)
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isFocused ? .blue : .secondary)
                    .animation(.easeInOut(duration: 0.2), value: isFocused)
                
                Spacer()
            }
            
            HStack {
                Group {
                    if isVisible {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                    }
                }
                .font(.system(size: 16, weight: .regular))
                .focused($isFocused)
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isVisible.toggle()
                    }
                }) {
                    Image(systemName: isVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.secondary.opacity(0.8))
                        .font(.system(size: 16))
                }
            }
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
            .animation(.easeInOut(duration: 0.2), value: isFocused)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        ModernSecureField(
            title: "Contraseña",
            text: .constant(""),
            placeholder: "Mínimo 8 caracteres",
            isVisible: .constant(true)
        )
        
        ModernSecureField(
            title: "Confirmar Contraseña",
            text: .constant("password123"),
            placeholder: "Repite tu contraseña",
            isVisible: .constant(false)
        )
    }
    .padding()
}
