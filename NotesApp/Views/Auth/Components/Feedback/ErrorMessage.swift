//
//  ErrorMessage.swift
//  TypeNote
//
//  Created by Milward on 21/06/25.
//

import SwiftUI

struct ErrorMessage: View {
    let message: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
                .font(.system(size: 16))
            
            Text(message)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.red)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.red.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.red.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#Preview {
    VStack {
        ErrorMessage(message: "Correo electrónico o contraseña incorrectos")
        ErrorMessage(message: "Este es un mensaje de error más largo para probar cómo se ve el componente con texto extenso")
    }
    .padding()
}
