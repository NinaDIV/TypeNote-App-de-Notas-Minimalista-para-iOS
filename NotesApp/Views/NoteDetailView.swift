import SwiftUI

struct NoteDetailView: View {
    @EnvironmentObject var viewModel: NotesViewModel
    @Environment(\.dismiss) private var dismiss
    
    let noteId: String
    @State private var note: Note?
    @State private var editedTitle: String = ""
    @State private var editedContent: String = ""
    @State private var selectedCategoryId: String = "default"
    
    // Estados para UI
    @State private var isEditing: Bool = false
    @State private var showingCategoryPicker: Bool = false
    @State private var showingDeleteAlert: Bool = false
    @State private var isLoading: Bool = true
    @State private var hasChanges: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    // Header con información de la nota
                    noteHeaderView
                    
                    // Contenido principal
                    VStack(spacing: 24) {
                        // Campo de título
                        titleField
                        
                        // Campo de contenido
                        contentField
                        
                        // Opciones de personalización
                        if isEditing {
                            customizationSection
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
            .background(noteBackgroundColor)
        }
        .navigationBarHidden(true)
        .overlay(
            // Barra de herramientas flotante
            toolbarView,
            alignment: .bottom
        )
        .onAppear {
            loadNote()
        }
        .sheet(isPresented: $showingCategoryPicker) {
            CategoryPickerView(selectedCategoryId: $selectedCategoryId)
        }
        .alert("Eliminar nota", isPresented: $showingDeleteAlert) {
            Button("Cancelar", role: .cancel) { }
            Button("Eliminar", role: .destructive) {
                deleteNote()
            }
        } message: {
            Text("Esta acción no se puede deshacer.")
        }
        .onChange(of: editedTitle) { _, _ in hasChanges = true }
        .onChange(of: editedContent) { _, _ in hasChanges = true }
        .onChange(of: selectedCategoryId) { _, _ in hasChanges = true }
    }
    
    // MARK: - Header View
    private var noteHeaderView: some View {
        VStack(spacing: 16) {
            // Barra superior
            HStack {
                Button(action: { handleBackAction() }) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                        Text("Atrás")
                            .font(.system(size: 16))
                    }
                    .foregroundColor(.primary)
                }
                
                Spacer()
                
                HStack(spacing: 16) {
                    if isEditing {
                        Button("Cancelar") {
                            cancelEditing()
                        }
                        .foregroundColor(.secondary)
                        
                        Button("Guardar") {
                            saveNote()
                        }
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                        .disabled(!canSave)
                    } else {
                        Button("Editar") {
                            startEditing()
                        }
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            
            // Información de la nota
            if let note = note {
                HStack {
                    Text(note.categoryIcon)
                        .font(.title2)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(note.categoryName)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Text(note.relativeDate)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // Indicador de color si tiene uno
                    if let colorId = note.colorId, colorId != "default" {
                        Circle()
                            .fill(note.noteColor)
                            .frame(width: 16, height: 16)
                    }
                    
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
                .padding(.horizontal, 20)
            }
        }
        .background(Color(.systemBackground).opacity(0.95))
        .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
    }
    
    // MARK: - Title Field
    private var titleField: some View {
        VStack(alignment: .leading, spacing: 8) {
            if isEditing {
                TextField("Título de la nota", text: $editedTitle)
                    .font(.system(size: 24, weight: .bold))
                    .textFieldStyle(PlainTextFieldStyle())
            } else {
                Text(note?.title.isEmpty == true ? "Sin título" : note?.title ?? "")
                    .font(.system(size: 24, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.top, 24)
    }
    
    // MARK: - Content Field
    private var contentField: some View {
        VStack(alignment: .leading, spacing: 8) {
            if isEditing {
                VStack(spacing: 0) {
                    TextEditor(text: $editedContent)
                        .font(.system(size: 16))
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .frame(minHeight: 200)
                }
            } else {
                Text(note?.content.isEmpty == true ? "Sin contenido" : note?.content ?? "")
                    .font(.system(size: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
    
    // MARK: - Customization Section
    private var customizationSection: some View {
        VStack(spacing: 16) {
            Divider()
                .padding(.vertical, 8)
            
            VStack(spacing: 12) {
                // Selector de categoría
                HStack {
                    Text("Categoría")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Button(action: { showingCategoryPicker = true }) {
                        HStack(spacing: 8) {
                            Text(NoteCategory.getCategory(by: selectedCategoryId)?.icon ?? "📄")
                                .font(.system(size: 16))
                            Text(NoteCategory.getCategory(by: selectedCategoryId)?.name ?? "General")
                                .font(.subheadline)
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color(.systemGray6).opacity(0.5))
            .cornerRadius(12)
        }
    }
    
    // MARK: - Toolbar View
    private var toolbarView: some View {
        HStack(spacing: 20) {
            if isEditing {
                Button(action: { showingCategoryPicker = true }) {
                    Image(systemName: "folder")
                        .font(.title3)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                Button(action: { showingDeleteAlert = true }) {
                    Image(systemName: "trash")
                        .font(.title3)
                        .foregroundColor(.red)
                }
            } else {
                Button(action: { shareNote() }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title3)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                Button(action: { duplicateNote() }) {
                    Image(systemName: "doc.on.doc")
                        .font(.title3)
                        .foregroundColor(.primary)
                }
                
                Button(action: { showingDeleteAlert = true }) {
                    Image(systemName: "trash")
                        .font(.title3)
                        .foregroundColor(.red)
                }
            }
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 34)
    }
    
    // MARK: - Computed Properties
    private var canSave: Bool {
        !editedTitle.trimmingCharacters(in: .whitespaces).isEmpty ||
        !editedContent.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    private var noteBackgroundColor: Color {
        if let note = note, let colorId = note.colorId, colorId != "default" {
            return NoteColorOption.getColor(by: colorId)?.color.opacity(0.05) ?? Color(.systemBackground)
        }
        return Color(.systemBackground)
    }
    
    // MARK: - Helper Methods
    private func loadNote() {
        if let foundNote = viewModel.notes.first(where: { $0.noteId == noteId }) {
            self.note = foundNote
            self.editedTitle = foundNote.title
            self.editedContent = foundNote.content
            self.selectedCategoryId = foundNote.categoryId
            self.isLoading = false
        }
    }
    
    private func startEditing() {
        isEditing = true
        hasChanges = false
    }
    
    private func cancelEditing() {
        if hasChanges {
            // Restaurar valores originales
            if let originalNote = note {
                editedTitle = originalNote.title
                editedContent = originalNote.content
                selectedCategoryId = originalNote.categoryId
            }
        }
        isEditing = false
        hasChanges = false
    }
    
    private func saveNote() {
        Task {
            let success = await viewModel.updateNote(
                noteId: noteId,
                title: editedTitle,
                content: editedContent,
                categoryId: selectedCategoryId,
                colorId: note?.colorId
            )
            
            if success {
                await MainActor.run {
                    // Actualizar la nota local
                    if let index = viewModel.notes.firstIndex(where: { $0.noteId == noteId }) {
                        var updatedNote = viewModel.notes[index]
                        updatedNote.title = editedTitle
                        updatedNote.content = editedContent
                        updatedNote.categoryId = selectedCategoryId
                        
                        viewModel.notes[index] = updatedNote
                        self.note = updatedNote
                    }
                    
                    isEditing = false
                    hasChanges = false
                }
            }
        }
    }
    
    private func handleBackAction() {
        if hasChanges && isEditing {
            saveNote()
        }
        dismiss()
    }
    
    private func deleteNote() {
        Task {
            await viewModel.deleteNote(noteId: noteId)
            await MainActor.run {
                dismiss()
            }
        }
    }
    
    private func shareNote() {
        guard let note = note else { return }
        let shareText = "\(note.title)\n\n\(note.content)"
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
    
    private func duplicateNote() {
        guard let note = note else { return }
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
