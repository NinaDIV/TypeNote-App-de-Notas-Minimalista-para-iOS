//
//  AppLogo.swift
//  TypeNote
//
//  Created by Milward on 21/06/25.
//

import SwiftUI

struct AppLogo: View {
    @State private var isPressed = false
    
    var body: some View {
        ZStack {
            // Sombra exterior suave
            Circle()
                .fill(Color.black.opacity(0.08))
                .frame(width: 108, height: 108)
                .blur(radius: 8)
                .offset(y: 4)
            
            // Base del logo
            RoundedRectangle(cornerRadius: 22)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(.systemGray6),
                            Color(.systemGray5).opacity(0.8)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 96, height: 96)
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.6),
                                    Color.clear,
                                    Color.black.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 6)
            
            // Imagen del logo o fallback
            Group {
                if let logo = UIImage(named: "Logo") {
                    Image(uiImage: logo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 56, height: 56)
                } else {
                    Text("T")
                        .font(.system(size: 36, weight: .light, design: .serif))
                        .foregroundColor(.primary.opacity(0.8))
                }
            }
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onTapGesture {
            isPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
            }
        }
    }
}

#Preview {
    AppLogo()
        .padding()
}
