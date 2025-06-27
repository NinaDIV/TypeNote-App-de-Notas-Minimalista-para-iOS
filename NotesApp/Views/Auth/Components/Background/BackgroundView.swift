//
//  BackgroundView.swift
//  TypeNote
//
//  Created by Milward on 21/06/25.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        Rectangle()
            .fill(
                RadialGradient(
                    colors: [
                        Color(.systemBackground),
                        Color(.systemGray6).opacity(0.4),
                        Color(.systemGray5).opacity(0.2)
                    ],
                    center: .topLeading,
                    startRadius: 100,
                    endRadius: 800
                )
            )
            .overlay(
                // Patrón de escritura más elegante
                VStack(spacing: 28) {
                    ForEach(0..<25, id: \.self) { index in
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.primary.opacity(0.02),
                                        Color.clear,
                                        Color.primary.opacity(0.01)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(height: 0.8)
                            .opacity(Double.random(in: 0.3...0.8))
                    }
                }
                .padding(.top, 120)
                .padding(.horizontal, 40)
            )
    }
}

#Preview {
    BackgroundView()
}
