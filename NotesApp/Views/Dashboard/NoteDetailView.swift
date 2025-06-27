import SwiftUI

struct NoteDetailView: View {
    @EnvironmentObject var viewModel: NotesViewModel
    @Environment(\.dismiss) private var dismiss
    
    let noteId: String
    @State private var note: Note?
    @State private var editedTitle: String = ""
    @State private var editedContent: String = ""
    @State private var selectedCategoryId: String = "default"
    @State private var selectedColorId: String = "default"
    
    // Estados para UI
    @State private var isEditing: Bool = false
    @State private var showingCategoryPicker: Bool = false
    @State private var showingColorPicker: Bool = false
    @State private var showingDeleteAlert: Bool = false
    @State private var isLoading: Bool = true
    @State private var hasChanges: Bool = false
    @FocusState private var isTitleFocused: Bool
    @FocusState private var isContentFocused: Bool
    
    // ✅ NUEVO: Sistema de colores dinámico como en las otras vistas
    private var primaryColor: Color {
        if let colorModel = selectedColorModel, selectedColorId != "default" {
            return colorModel.color
        }
        return selectedCategoryModel?.color ?? .blue
    }
    
    private var hasCustomColor: Bool {
        return selectedColorId != "default"
    }
    
    private var selectedCategoryModel: NoteCategory? {
        NoteCategory.getCategory(by: selectedCategoryId)
    }
    
    private var selectedColorModel: NoteColorOption? {
        NoteColorOption.getColor(by: selectedColorId)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // ✅ MEJORA: Fondo elegante con gradiente
                noteBackgroundColor
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Header con información de la nota mejorado
                        noteHeaderView
                        
                        // Contenido principal
                        VStack(spacing: 28) {
                            // ✅ MEJORA: Indicadores visuales como en CreateNoteView
                            if isEditing {
                                editingHeaderSection
                            } else {
                                viewingHeaderSection
                            }
                            
                            // Campo de título mejorado
                            titleField
                            
                            // Campo de contenido mejorado
                            contentField
                            
                            // Opciones de personalización mejoradas
                            if isEditing {
                               
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .overlay(
            // Barra de herramientas flotante mejorada
            toolbarView,
            alignment: .bottom
        )
        .onAppear {
            loadNote()
        }
        .sheet(isPresented: $showingCategoryPicker) {
            CategoryPickerView(selectedCategoryId: $selectedCategoryId)
        }
        .sheet(isPresented: $showingColorPicker) {
            ColorPickerView(selectedColorId: $selectedColorId)
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
        .onChange(of: selectedColorId) { _, _ in hasChanges = true }
        
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Header View Mejorado
    private var noteHeaderView: some View {
        VStack(spacing: 20) {
            // Barra superior con estilo refinado
            HStack {
                Button(action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                    handleBackAction()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                        Text("Atrás")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(primaryColor)
                }
                
                Spacer()
                
                HStack(spacing: 16) {
                    if isEditing {
                        Button("Cancelar") {
                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                            impactFeedback.impactOccurred()
                            cancelEditing()
                        }
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                        
                        Button("Guardar") {
                            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                            impactFeedback.impactOccurred()
                            saveNote()
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(canSave ? primaryColor : .secondary)
                        .disabled(!canSave)
                    } else {
                        Button("Editar") {
                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                            impactFeedback.impactOccurred()
                            startEditing()
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(primaryColor)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.systemBackground).opacity(0.98),
                    Color(.systemBackground).opacity(0.92)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .shadow(color: primaryColor.opacity(0.06), radius: 8, x: 0, y: 2)
    }
    
    // ✅ NUEVO: Header para modo edición con indicadores visuales
    private var editingHeaderSection: some View {
        HStack {
            HStack(spacing: 12) {
                // Icono de categoría con fondo circular
                ZStack {
                    Circle()
                        .fill(primaryColor.opacity(hasCustomColor ? 0.15 : 0.1))
                        .frame(width: 32, height: 32)
                    
                    Text(selectedCategoryModel?.icon ?? "📄")
                        .font(.system(size: 16, weight: .medium))
                }
                
                // Indicador de color personalizado
                if hasCustomColor {
                    Circle()
                        .fill(primaryColor)
                        .frame(width: 8, height: 8)
                        .shadow(color: primaryColor.opacity(0.4), radius: 2, x: 0, y: 1)
                }
                
                // Tag de categoría
                HStack(spacing: 6) {
                    Text(selectedCategoryModel?.name ?? "General")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(primaryColor)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(primaryColor.opacity(0.1))
                )
            }
            
            Spacer()
            
            // Indicador de edición
            HStack(spacing: 4) {
                Circle()
                    .fill(primaryColor)
                    .frame(width: 5, height: 5)
                    .shadow(color: primaryColor.opacity(0.4), radius: 2, x: 0, y: 1)
                
                Text("Editando")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(primaryColor)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(primaryColor.opacity(0.08))
            )
        }
        .padding(.horizontal, 4)
    }
    
    // ✅ NUEVO: Header para modo visualización
    private var viewingHeaderSection: some View {
        Group {
            if let note = note {
                HStack {
                    HStack(spacing: 12) {
                        // Icono de categoría con fondo circular
                        ZStack {
                            Circle()
                                .fill(primaryColor.opacity(hasCustomColor ? 0.15 : 0.1))
                                .frame(width: 32, height: 32)
                            
                            Text(note.categoryIcon)
                                .font(.system(size: 16, weight: .medium))
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(note.categoryName)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.primary)
                            
                            Text(note.relativeDate)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        
                        // Indicador de color personalizado
                        if let colorId = note.colorId, colorId != "default" {
                            Circle()
                                .fill(note.noteColor)
                                .frame(width: 8, height: 8)
                                .shadow(color: note.noteColor.opacity(0.4), radius: 2, x: 0, y: 1)
                        }
                    }
                    
                    Spacer()
                    
                    // Indicadores de estado
                    HStack(spacing: 12) {
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
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(primaryColor.opacity(0.08))
                            )
                        }
                        
                        Text(note.readingTime)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
    
    // MARK: - Title Field Mejorado
    private var titleField: some View {
        VStack(alignment: .leading, spacing: 12) {
            if isEditing {
                TextField("Título de la nota", text: $editedTitle)
                    .font(.system(size: 26, weight: .bold))
                    .focused($isTitleFocused)
                    .submitLabel(.next)
                    .onSubmit { isContentFocused = true }
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.horizontal, 24)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                isTitleFocused ? primaryColor.opacity(0.4) : Color(.systemGray5).opacity(0.6),
                                lineWidth: isTitleFocused ? 1.5 : 0.8
                            )
                            .animation(.easeInOut(duration: 0.2), value: isTitleFocused)
                    )
            } else {
                Text(note?.title.isEmpty == true ? "Sin título" : note?.title ?? "")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 4)
            }
        }
    }
    
    // MARK: - Content Field Mejorado
    private var contentField: some View {
        VStack(alignment: .leading, spacing: 12) {
            if isEditing {
                ZStack(alignment: .topLeading) {
                    // Placeholder mejorado
                    if editedContent.isEmpty {
                        Text("Escribe aquí el contenido de tu nota...")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .allowsHitTesting(false)
                    }
                    
                    TextEditor(text: $editedContent)
                        .font(.system(size: 16))
                        .focused($isContentFocused)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .frame(minHeight: 250)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                }
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            isContentFocused ? primaryColor.opacity(0.4) : Color(.systemGray5).opacity(0.6),
                            lineWidth: isContentFocused ? 1.5 : 0.8
                        )
                        .animation(.easeInOut(duration: 0.2), value: isContentFocused)
                )
            } else {
                ScrollView {
                    Text(note?.content.isEmpty == true ? "Sin contenido" : note?.content ?? "")
                        .font(.system(size: 16))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 4)
                }
                .frame(minHeight: 200)
            }
        }
    }
    
 
    
    // ✅ NUEVO: Row component reutilizable
    private func customizationRow<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            action()
        }) {
            HStack {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.primary)
                
                Spacer()
                
                content()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // ✅ NUEVO: Indicador de color mejorado
    private var colorIndicatorImproved: some View {
        Group {
            if selectedColorId == "default" {
                ZStack {
                    Circle()
                        .fill(Color(.systemGray6))
                        .frame(width: 24, height: 24)
                    
                    Circle()
                        .stroke(Color(.systemGray4), lineWidth: 1.5)
                        .frame(width: 24, height: 24)
                }
            } else {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                primaryColor,
                                primaryColor.opacity(0.8)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 24, height: 24)
                    .shadow(color: primaryColor.opacity(0.4), radius: 3, x: 0, y: 2)
                    .overlay(
                        Circle()
                            .stroke(Color(.systemBackground), lineWidth: 2)
                            .frame(width: 24, height: 24)
                    )
            }
        }
    }
    
    // MARK: - Toolbar View Mejorada
    private var toolbarView: some View {
        HStack(spacing: 24) {
            if isEditing {
                // Botón de color
                Button(action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                    showingColorPicker = true
                }) {
                    ZStack {
                        Circle()
                            .fill(Color(.systemBackground))
                            .frame(width: 44, height: 44)
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        
                        Image(systemName: "paintpalette.fill")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(primaryColor)
                    }
                }
                
                // Botón de categoría
                Button(action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                    showingCategoryPicker = true
                }) {
                    ZStack {
                        Circle()
                            .fill(Color(.systemBackground))
                            .frame(width: 44, height: 44)
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        
                        Image(systemName: "folder.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(primaryColor)
                    }
                }
                
                Spacer()
                
                // Botón eliminar
                Button(action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    showingDeleteAlert = true
                }) {
                    ZStack {
                        Circle()
                            .fill(Color(.systemBackground))
                            .frame(width: 44, height: 44)
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        
                        Image(systemName: "trash.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.red)
                    }
                }
            } else {
                // Botón compartir
                Button(action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                    shareNote()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color(.systemBackground))
                            .frame(width: 44, height: 44)
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        
                        Image(systemName: "square.and.arrow.up.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(primaryColor)
                    }
                }
                
                Spacer()
                
                // Botón duplicar
                Button(action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                    duplicateNote()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color(.systemBackground))
                            .frame(width: 44, height: 44)
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        
                        Image(systemName: "doc.on.doc.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(primaryColor)
                    }
                }
                
                // Botón eliminar
                Button(action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    showingDeleteAlert = true
                }) {
                    ZStack {
                        Circle()
                            .fill(Color(.systemBackground))
                            .frame(width: 44, height: 44)
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        
                        Image(systemName: "trash.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(.systemBackground).opacity(0.98),
                            Color(.systemBackground).opacity(0.92)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: primaryColor.opacity(0.08), radius: 12, x: 0, y: 4)
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .stroke(primaryColor.opacity(0.12), lineWidth: 1)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 34)
    }
    
    // MARK: - Computed Properties
    private var canSave: Bool {
        !editedTitle.trimmingCharacters(in: .whitespaces).isEmpty ||
        !editedContent.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    // ✅ MEJORA: Fondo con gradiente más sofisticado
    private var noteBackgroundColor: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(.systemGroupedBackground),
                primaryColor.opacity(hasCustomColor ? 0.06 : 0.03),
                Color(.systemGroupedBackground)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // MARK: - Helper Methods
    private func loadNote() {
        if let foundNote = viewModel.notes.first(where: { $0.noteId == noteId }) {
            self.note = foundNote
            self.editedTitle = foundNote.title
            self.editedContent = foundNote.content
            self.selectedCategoryId = foundNote.categoryId
            self.selectedColorId = foundNote.colorId ?? "default"
            self.isLoading = false
        }
    }
    
    private func startEditing() {
        isEditing = true
        hasChanges = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isTitleFocused = true
        }
    }
    
    private func cancelEditing() {
        if hasChanges {
            // Restaurar valores originales
            if let originalNote = note {
                editedTitle = originalNote.title
                editedContent = originalNote.content
                selectedCategoryId = originalNote.categoryId
                selectedColorId = originalNote.colorId ?? "default"
            }
        }
        isEditing = false
        hasChanges = false
    }
    
    private func saveNote() {
        // Feedback háptico
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        Task {
            let success = await viewModel.updateNote(
                noteId: noteId,
                title: editedTitle.isEmpty ? "Sin título" : editedTitle,
                content: editedContent,
                categoryId: selectedCategoryId,
                colorId: selectedColorId == "default" ? nil : selectedColorId
            )
            
            if success {
                await MainActor.run {
                    // Actualizar la nota local
                    if let index = viewModel.notes.firstIndex(where: { $0.noteId == noteId }) {
                        var updatedNote = viewModel.notes[index]
                        updatedNote.title = editedTitle
                        updatedNote.content = editedContent
                        updatedNote.categoryId = selectedCategoryId
                        updatedNote.colorId = selectedColorId == "default" ? nil : selectedColorId
                        
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
