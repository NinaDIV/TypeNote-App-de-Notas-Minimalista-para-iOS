//
//  HeaderSection.swift
//  TypeNote
//
//  Created by Milward on 21/06/25.
//

import SwiftUI

struct HeaderSection: View {
    var body: some View {
        VStack(spacing: 28) {
            // Logo con animación
            AppLogo()
            
            // Texto principal
            VStack(spacing: 16) {
                Text("TypeNote")
                    .font(.system(size: 38, weight: .ultraLight, design: .serif))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.primary, .primary.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .tracking(1.2)
                
                Text("Donde cada palabra cuenta")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.secondary)
                    .tracking(0.5)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    HeaderSection()
        .padding()
}
