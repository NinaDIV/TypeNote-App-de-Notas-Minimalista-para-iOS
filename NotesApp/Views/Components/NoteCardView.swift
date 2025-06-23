//
//  NotionCardView.swift
//  NotesApp
//
//  Created by Milward on 22/06/25.
//

import SwiftUI

struct NotionCardView: View {
    let note: Note
    @EnvironmentObject var viewModel: NotesViewModel
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header con ícono y menú
            HStack {
                categoryIcon
                    .font(.title2)
                
                Spacer()
                
                Menu {
                    Button("Editar", systemImage: "pencil") {
                        // Implementar navegación a edición
                    }
                    
                    Button("Duplicar", systemImage: "doc.on.doc") {
                        // Implementar duplicación
                    }
                    
                    Divider()
                    
                    Button("Eliminar", systemImage: "trash", role: .destructive) {
                        showingDeleteAlert = true
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.secondary)
                        .font(.system(size: 16))
                        .frame(width: 32, height: 32)
                        .contentShape(Rectangle())
                }
                .menuStyle(BorderlessButtonMenuStyle())
            }
            
            // Título
            Text(note.title.isEmpty ? "Sin título" : note.title)
                .font(.system(size: 18, weight: .semibold))
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            // Preview del contenido
            if !note.contentPreview.isEmpty {
                Text(note.contentPreview)
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            // Footer
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(note.categoryName)
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(.systemGray5))
                        .cornerRadius(6)
                    
                    Spacer()
                    
                    if note.isRecent {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 6, height: 6)
                            Text("Nuevo")
                                .font(.caption2)
                                .foregroundColor(.blue)
                                .fontWeight(.medium)
                        }
                    }
                }
                
                HStack {
                    Text(note.relativeDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(note.readingTime)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(20)
        .frame(minHeight: 180)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray6), lineWidth: 0.5)
        )
        .alert("Eliminar nota", isPresented: $showingDeleteAlert) {
            Button("Cancelar", role: .cancel) { }
            Button("Eliminar", role: .destructive) {
                Task {
                    await viewModel.deleteNote(noteId: note.noteId)
                }
            }
        } message: {
            Text("Esta acción no se puede deshacer.")
        }
    }
    
    private var categoryIcon: some View {
        Text(note.categoryIcon)
            .font(.system(size: 20))
    }
}
