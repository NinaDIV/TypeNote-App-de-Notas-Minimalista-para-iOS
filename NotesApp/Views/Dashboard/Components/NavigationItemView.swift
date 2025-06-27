//
//  NavigationItemView.swift
//  NotesApp
//
//  Created by Milward on 22/06/25.
//

import SwiftUI

struct NavigationItemView: View {
    let icon: String
    let title: String
    let count: Int
    let isSelected: Bool
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            action()
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        }) {
            HStack(spacing: 14) {
                // Icono con círculo de fondo
                ZStack {
                    Circle()
                        .fill(isSelected ? .blue.opacity(0.15) : Color(.systemGray6))
                        .frame(width: 28, height: 28)
                    
                    if icon.count == 1 {
                        Text(icon)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(isSelected ? .blue : .secondary)
                    } else {
                        Image(systemName: icon)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(isSelected ? .blue : .secondary)
                    }
                }
                
                Text(title)
                    .font(.system(size: 15, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? .blue : .primary)
                
                Spacer()
                
                if count > 0 {
                    Text("\(count)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color(.systemGray5).opacity(0.8))
                        .cornerRadius(6)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? .blue.opacity(0.06) : Color.clear)
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}
