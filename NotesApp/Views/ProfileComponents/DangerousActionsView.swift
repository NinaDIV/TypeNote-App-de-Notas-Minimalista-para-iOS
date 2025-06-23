//
//  DangerousActionsView.swift
//  NotesApp
//
//  Created by Milward on 22/06/25.
//

import SwiftUI

struct DangerousActionsView: View {
    @EnvironmentObject var viewModel: NotesViewModel
    @Binding var showingLogoutAlert: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Cuenta")
                .font(.title2)
                .fontWeight(.semibold)
            
            // Cerrar sesión
            Button(action: { showingLogoutAlert = true }) {
                HStack(spacing: 16) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 20))
                        .foregroundColor(.red)
                        .frame(width: 24, alignment: .center)
                    
                    Text("Cerrar sesión")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.red)
                    
                    Spacer()
                }
                .padding(16)
            }
            .buttonStyle(PlainButtonStyle())
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray5), lineWidth: 0.5)
            )
        }
        .alert("Cerrar sesión", isPresented: $showingLogoutAlert) {
            Button("Cancelar", role: .cancel) { }
            Button("Cerrar sesión", role: .destructive) {
                Task {
                    await viewModel.signOut()
                }
            }
        } message: {
            Text("¿Estás seguro de que quieres cerrar sesión?")
        }
    }
}
