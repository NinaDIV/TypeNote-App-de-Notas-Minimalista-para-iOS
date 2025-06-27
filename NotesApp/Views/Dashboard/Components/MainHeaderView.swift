//
//  MainHeaderView.swift
//  NotesApp
//
//  Created by Milward on 22/06/25.
//

import SwiftUI

struct MainHeaderView: View {
    @EnvironmentObject var viewModel: NotesViewModel
    @Binding var showCreateView: Bool
    @Binding var showProfileView: Bool
    @State private var isPressedProfile = false
    @State private var isPressedCreate = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Botón de perfil con diseño mejorado
            Button(action: {
                showProfileView = true
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
            }) {
                HStack(spacing: 14) {
                    // Avatar/Logo con gradiente sutil
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(.systemGray6),
                                        Color(.systemGray5).opacity(0.6)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 40, height: 40)
                        
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "doc.text.fill")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.blue)
                    }
                    .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)
                    
                    // Información del usuario
                    VStack(alignment: .leading, spacing: 3) {
                        Text("TypeNote")
                            .font(.system(size: 22, weight: .light, design: .serif))
                            .tracking(1.2)
                            .foregroundColor(.primary)
                        
                        HStack(spacing: 4) {
                            Text("de")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.secondary)
                            
                            Text(getShortUserName())
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            .scaleEffect(isPressedProfile ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressedProfile)
            .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                isPressedProfile = pressing
            }, perform: {})
            
            Spacer()
            
            // Botón Nueva con diseño premium
            Button(action: {
                showCreateView = true
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Nueva")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .background(
                    // Gradiente azul elegante
                    LinearGradient(
                        colors: [
                            Color.blue,
                            Color.blue.opacity(0.8)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: .blue.opacity(0.3), radius: 12, x: 0, y: 6)
                .overlay(
                    // Brillo sutil en la parte superior
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.3),
                                    Color.clear
                                ],
                                startPoint: .top,
                                endPoint: .center
                            )
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
            .scaleEffect(isPressedCreate ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressedCreate)
            .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                isPressedCreate = pressing
            }, perform: {})
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 20)
        .background(
            // Fondo con gradiente sutil
            LinearGradient(
                colors: [
                    Color(.systemBackground),
                    Color(.systemBackground).opacity(0.95)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .overlay(
            // Borde inferior sutil
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.clear,
                            Color.primary.opacity(0.04),
                            Color.clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
                .opacity(0.6),
            alignment: .bottom
        )
    }
    
    // MARK: - Helper Methods
    private func getShortUserName() -> String {
        if !viewModel.currentUserName.isEmpty {
            let components = viewModel.currentUserName.components(separatedBy: " ")
            return components.first ?? "Usuario"
        } else {
            let components = viewModel.currentUser.components(separatedBy: "@")
            return components.first ?? "Usuario"
        }
    }
}

// MARK: - Preview
#Preview {
    MainHeaderView(
        showCreateView: .constant(false),
        showProfileView: .constant(false)
    )
    .environmentObject(NotesViewModel())
}
