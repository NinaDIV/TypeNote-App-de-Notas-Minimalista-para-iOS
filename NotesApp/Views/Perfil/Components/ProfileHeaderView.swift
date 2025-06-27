//
//  ProfileHeaderView.swift
//  NotesApp
//
//  Created by Milward on 22/06/25.
//

import SwiftUI

struct ProfileHeaderView: View {
    @EnvironmentObject var viewModel: NotesViewModel
    @Binding var userName: String
    let dismiss: DismissAction
    
    var body: some View {
        VStack(spacing: 20) {
            // Avatar grande
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.blue, .blue.opacity(0.7)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 100, height: 100)
                
                Text(viewModel.getUserInitials())
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
            }
            
            // Editor de nombre
            VStack(alignment: .leading, spacing: 12) {
                Text("Nombre completo")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                TextField("Tu nombre", text: $userName)
                    .font(.title3)
                    .fontWeight(.medium)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
            }
            
            // Botón guardar
            Button("Guardar cambios") {
                viewModel.saveUserName(userName)
                dismiss()
            }
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray : Color.blue)
            .cornerRadius(12)
            .disabled(userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(24)
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(16)
    }
}
