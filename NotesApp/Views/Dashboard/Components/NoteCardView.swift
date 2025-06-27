import SwiftUI

struct NoteCardView: View {
    let note: Note
    let onTap: () -> Void

    @EnvironmentObject var viewModel: NotesViewModel
    @State private var showingDeleteAlert = false
    @State private var isPressed = false
    @State private var showMenu = false

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
            // Feedback háptico similar al SearchBar
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            onTap()
        }) {
            VStack(alignment: .leading, spacing: 16) {
                // Header con mejor integración de colores
                HStack {
                    HStack(spacing: 8) {
                        // Icono de categoría con fondo circular como en SearchBar
                        ZStack {
                            Circle()
                                .fill(primaryColor.opacity(hasCustomColor ? 0.15 : 0.1))
                                .frame(width: 28, height: 28)
                            
                            Text(note.categoryIcon)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(primaryColor)
                        }
                        
                        // ✅ Indicador de color si tiene color personalizado
                        if hasCustomColor {
                            Circle()
                                .fill(primaryColor)
                                .frame(width: 6, height: 6)
                                .shadow(color: primaryColor.opacity(0.4), radius: 2, x: 0, y: 1)
                        }
                    }
                    
                    Spacer()
                    
                    // Menú mejorado con animaciones suaves
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
                        ZStack {
                            Circle()
                                .fill(Color(.systemGray6).opacity(showMenu ? 1.0 : 0.6))
                                .frame(width: 28, height: 28)
                            
                            Image(systemName: "ellipsis")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(showMenu ? .blue : .secondary)
                        }
                        .scaleEffect(showMenu ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: showMenu)
                    }
                    .menuStyle(BorderlessButtonMenuStyle())
                    .onTapGesture { } // previene navegación involuntaria
                    .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                        withAnimation(.easeInOut(duration: 0.1)) {
                            showMenu = pressing
                        }
                    }, perform: {})
                }
                
                // Título con mejor tipografía
                Text(note.title.isEmpty ? "Sin título" : note.title)
                    .font(.system(size: 18, weight: .semibold))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.primary)
                
                // Preview con mejor espaciado
                if !note.contentPreview.isEmpty {
                    Text(note.contentPreview)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(2)
                }

                Spacer()

                // Footer mejorado con estilo de SearchBar
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        // ✅ Tag de categoría con estilo similar al dropdown
                        HStack(spacing: 6) {
                            Text(note.categoryName)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(primaryColor)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(primaryColor.opacity(0.1))
                        )
                        
                        Spacer()
                        
                        // ✅ Indicador "Nuevo" mejorado
                        if note.isRecent {
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(primaryColor)
                                    .frame(width: 5, height: 5)
                                    .shadow(color: primaryColor.opacity(0.4), radius: 2, x: 0, y: 1)
                                
                                Text("Nuevo")
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(primaryColor)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(primaryColor.opacity(0.08))
                            )
                        }
                    }
                    
                    // Separador sutil
                    Rectangle()
                        .fill(Color(.systemGray5).opacity(0.6))
                        .frame(height: 0.5)
                    
                    HStack {
                        Text(note.relativeDate)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text(note.readingTime)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(20)
            .frame(minHeight: 180)
            .background(
                // ✅ Fondo mejorado con gradiente más sutil
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(.systemBackground),
                                primaryColor.opacity(hasCustomColor ? 0.04 : 0.02)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .overlay(
                // ✅ Borde más elegante
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        primaryColor.opacity(hasCustomColor ? 0.3 : 0.2),
                        lineWidth: hasCustomColor ? 1.2 : 0.8
                    )
            )
            .overlay(
                // ✅ Barra de acento más refinada
                RoundedRectangle(cornerRadius: 2)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                primaryColor,
                                primaryColor.opacity(0.7)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 0)
                    .padding(.leading, 0),
                alignment: .leading
            )
            .shadow(
                color: hasCustomColor ? primaryColor.opacity(0.12) : .black.opacity(0.06),
                radius: isPressed ? 12 : 8,
                x: 0,
                y: isPressed ? 4 : 2
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
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
        // Feedback háptico para la acción
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
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
 
