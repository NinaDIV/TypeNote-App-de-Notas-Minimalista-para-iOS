//
//  PremiumButton.swift
//  TypeNote
//
//  Created by Milward on 21/06/25.
//

import SwiftUI

struct PremiumButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    var isLoading: Bool = false
    var isDisabled: Bool = false
    let style: ButtonStyle
    
    @State private var isPressed = false
    
    enum ButtonStyle {
        case primary, secondary, tertiary
        
        var configuration: (background: Color, foreground: Color, shadowColor: Color, shadowRadius: CGFloat) {
            switch self {
            case .primary:
                return (.blue, .white, .blue.opacity(0.3), 12)
            case .secondary:
                return (.green, .white, .green.opacity(0.25), 10)
            case .tertiary:
                return (Color(.systemGray5), .primary, .clear, 0)
            }
        }
    }
    
    var body: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            action()
        }) {
            HStack(spacing: 12) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.9)
                        .tint(style.configuration.foreground)
                } else {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                }
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(style.configuration.foreground)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(style.configuration.background)
                    .shadow(
                        color: style.configuration.shadowColor,
                        radius: isDisabled ? 0 : style.configuration.shadowRadius,
                        x: 0,
                        y: isDisabled ? 0 : 6
                    )
            )
            .opacity(isDisabled ? 0.5 : 1.0)
            .scaleEffect(isPressed ? 0.96 : 1.0)
        }
        .disabled(isDisabled || isLoading)
        .animation(.easeInOut(duration: 0.15), value: isDisabled)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

#Preview {
    VStack(spacing: 16) {
        PremiumButton(
            title: "Primary Button",
            icon: "checkmark.circle.fill",
            action: {},
            style: .primary
        )
        
        PremiumButton(
            title: "Secondary Button",
            icon: "person.badge.plus",
            action: {},
            style: .secondary
        )
        
        PremiumButton(
            title: "Tertiary Button",
            icon: "arrow.left",
            action: {},
            style: .tertiary
        )
        
        PremiumButton(
            title: "Loading Button",
            icon: "checkmark.circle.fill",
            action: {},
            isLoading: true,
            style: .primary
        )
        
        PremiumButton(
            title: "Disabled Button",
            icon: "checkmark.circle.fill",
            action: {},
            isDisabled: true,
            style: .primary
        )
    }
    .padding()
}
