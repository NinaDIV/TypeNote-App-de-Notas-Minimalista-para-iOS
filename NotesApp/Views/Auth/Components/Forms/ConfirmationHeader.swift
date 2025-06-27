//
//  ConfirmationHeader.swift
//  TypeNote
//
//  Created by Milward on 21/06/25.
//

import SwiftUI

struct ConfirmationHeader: View {
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 64, height: 64)
                
                Image(systemName: "envelope.badge.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.blue)
            }
            
            VStack(spacing: 8) {
                Text("Confirma tu Email")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("Te hemos enviado un código de 6 dígitos\na tu correo electrónico")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
        }
        .padding(.bottom, 8)
    }
}

#Preview {
    ConfirmationHeader()
        .padding()
}
