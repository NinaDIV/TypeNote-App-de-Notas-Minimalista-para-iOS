import SwiftUI

struct NoteCardView: View {
    let note: Note
    let onTap: () -> Void

    @EnvironmentObject var viewModel: NotesViewModel
    @State private var showingDeleteAlert = false

    // ✅ Determina el color principal a usar (personalizado o de categoría)
    private var primaryColor: Color {
        if let colorId = note.colorId, colorId != "default" {
            return note.noteColor
        }
        return note.categoryColor
    }
    
    // ✅ Determina si debe usar el color personalizado o de categoría
    private var hasCustomColor: Bool {
        return note.colorId != nil && note.colorId != "default"
    }

    var body: some View {
        Button(action: {
            onTap() // ✅ Ejecuta la acción que se le pasa (por ejemplo, abrir detalle)
        }) {
            VStack(alignment: .leading, spacing: 16) {
                // Header con mejor integración de colores
                HStack {
                    HStack(spacing: 8) {
                        Text(note.categoryIcon)
                            .font(.title2)
                        
                        // ✅ Indicador de color si tiene color personalizado
                        if hasCustomColor {
                            Circle()
                                .fill(primaryColor)
                                .frame(width: 8, height: 8)
                        }
                    }
                    
                    Spacer()
                    
                    Menu {
                        Button("Editar", systemImage: "pencil") {
                            onTap()
                        }
                        
                        Button("Duplicar", systemImage: "doc.on.doc") {
                            duplicateNote()
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
                    .onTapGesture { } // previene navegación involuntaria
                }
                
                // Título
                Text(note.title.isEmpty ? "Sin título" : note.title)
                    .font(.system(size: 18, weight: .semibold))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.primary)
                
                // Preview
                if !note.contentPreview.isEmpty {
                    Text(note.contentPreview)
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                }

                Spacer()

                // Footer mejorado con colores de categoría
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        // ✅ Tag de categoría con color dinámico
                        Text(note.categoryName)
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(primaryColor.opacity(0.15))
                            .foregroundColor(primaryColor)
                            .cornerRadius(6)
                        
                        Spacer()
                        
                        // ✅ Indicador "Nuevo" con color de categoría
                        if note.isRecent {
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(primaryColor)
                                    .frame(width: 6, height: 6)
                                Text("Nuevo")
                                    .font(.caption2)
                                    .foregroundColor(primaryColor)
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
            .background(
                // ✅ Fondo con gradiente sutil usando el color de categoría/personalizado
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                primaryColor.opacity(hasCustomColor ? 0.08 : 0.05),
                                Color(.systemBackground)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .overlay(
                // ✅ Borde con color dinámico
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        primaryColor.opacity(hasCustomColor ? 0.4 : 0.3),
                        lineWidth: hasCustomColor ? 1.5 : 1
                    )
            )
            .overlay(
                // ✅ Barra de acento en el lado izquierdo
                Rectangle()
                    .fill(primaryColor)
                    .frame(width: 4)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 2)
                    )
                    .padding(.leading, 0),
                alignment: .leading
            )
            .shadow(
                color: hasCustomColor ? primaryColor.opacity(0.15) : .black.opacity(0.08),
                radius: 8,
                x: 0,
                y: 2
            )
        }
        .buttonStyle(PlainButtonStyle())
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

    // MARK: - Duplicar nota
    private func duplicateNote() {
        Task {
            await viewModel.createNote(
                title: "\(note.title) (Copia)",
                content: note.content,
                categoryId: note.categoryId,
                colorId: note.colorId
            )
        }
    }
}

// MARK: - Preview
#Preview {
    let sampleNotes = [
        Note(
            userId: "user1",
            noteId: "1",
            title: "Reunión de trabajo importante",
            content: "Discutir los nuevos objetivos del proyecto Q3, revisar métricas actuales y planificar estrategias de crecimiento para el próximo trimestre.",
            categoryId: "work",
            colorId: nil,
            createdAt: ISO8601DateFormatter().string(from: Date()),
            updatedAt: ISO8601DateFormatter().string(from: Date())
        ),
        Note(
            userId: "user1",
            noteId: "2",
            title: "Ideas para el fin de semana",
            content: "Visitar el nuevo museo de arte contemporáneo, hacer una caminata por el sendero del bosque, probar ese restaurante italiano que recomendó María.",
            categoryId: "personal",
            colorId: "blue",
            createdAt: ISO8601DateFormatter().string(from: Calendar.current.date(byAdding: .hour, value: -2, to: Date()) ?? Date()),
            updatedAt: ISO8601DateFormatter().string(from: Date())
        ),
        Note(
            userId: "user1",
            noteId: "3",
            title: "App móvil innovadora",
            content: "Desarrollar una aplicación que combine productividad con elementos de gamificación para hacer las tareas diarias más divertidas y motivadoras.",
            categoryId: "ideas",
            colorId: nil,
            createdAt: ISO8601DateFormatter().string(from: Calendar.current.date(byAdding: .hour, value: -1, to: Date()) ?? Date()),
            updatedAt: ISO8601DateFormatter().string(from: Date())
        )
    ]
    
    ScrollView {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ], spacing: 12) {
            ForEach(sampleNotes) { note in
                NoteCardView(note: note) {
                    print("Tapped note: \(note.title)")
                }
                .environmentObject(NotesViewModel())
            }
        }
        .padding()
    }
}
