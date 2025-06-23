//
//  UserInfoSimplifiedView.swift
//  NotesApp
//
//  Created by Milward on 22/06/25.
//

import SwiftUI

struct UserInfoSimplifiedView: View {
    @EnvironmentObject var viewModel: NotesViewModel
    @Binding var showProfileView: Bool
    
    var body: some View {
        Button(action: { showProfileView = true }) {
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 36, height: 36)
                    .overlay(
                        Text(viewModel.getUserInitials())
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(getShortUserName())
                        .font(.system(size: 15, weight: .medium))
                    
                    Text("Espacio personal")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .foregroundColor(.primary)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(12)
        .padding(.horizontal, 20)
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
