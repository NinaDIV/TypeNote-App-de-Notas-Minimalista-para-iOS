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
    
    var body: some View {
        HStack {
            // Título principal con solo una fracción del nombre - Clickeable
            Button(action: { showProfileView = true }) {
                HStack(spacing: 12) {
                    Image(systemName: "doc.text.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 0) {
                            Text("No-")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("tion")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        
                        Text("de \(getShortUserName())")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .foregroundColor(.primary)
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
            
            // Botones de acción
            HStack(spacing: 16) {
                Button(action: { showCreateView = true }) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus")
                        Text("Nueva")
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .font(.title3)
                        .foregroundColor(.primary)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color(.systemBackground))
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
