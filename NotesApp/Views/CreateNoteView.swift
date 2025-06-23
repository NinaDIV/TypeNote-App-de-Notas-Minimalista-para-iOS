import SwiftUI

struct CreateNoteView: View {
    @EnvironmentObject var viewModel: NotesViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var content = ""
    @State private var selectedCategory = "default"
    @State private var selectedColorId = "default"
    @State private var showingDiscardAlert = false
    @State private var showingColorPicker = false
    @State private var showingCategoryPicker = false
    @FocusState private var isTitleFocused: Bool
    @FocusState private var isContentFocused: Bool

    // ✅ MEJORA: Usar directamente el modelo NoteCategory
    private var availableCategories: [NoteCategory] {
        NoteCategory.getAllCategories()
    }
    
    // ✅ MEJORA: Usar directamente el modelo NoteColorOption
    private var availableColors: [NoteColorOption] {
        NoteColorOption.getAllColors()
    }
    
    // ✅ MEJORA: Computed property que usa el modelo
    private var selectedCategoryModel: NoteCategory? {
        NoteCategory.getCategory(by: selectedCategory)
    }
    
    private var selectedColorModel: NoteColorOption? {
        NoteColorOption.getColor(by: selectedColorId)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // ✅ MEJORA: Usar el modelo para el color de fondo
                noteBackgroundColor
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Campo de título
                        titleField
                        
                        // Campo de contenido
                        contentField
                        
                        // ✅ MEJORA: Sección de personalización usando el modelo
                        customizationSection
                    }
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("Nueva Nota")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        handleCancel()
                    }
                    .disabled(viewModel.isLoading)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        saveNote()
                    }
                    .disabled(!canSave || viewModel.isLoading)
                    .fontWeight(.semibold)
                }
            }
            .overlay(createNoteToolbar, alignment: .bottom)
            .alert("Error", isPresented: .constant(!viewModel.errorMessage.isEmpty)) {
                Button("OK") {
                    viewModel.clearError()
                }
            } message: {
                Text(viewModel.errorMessage)
            }
            .confirmationDialog("¿Descartar cambios?",
                                isPresented: $showingDiscardAlert,
                                titleVisibility: .visible) {
                Button("Descartar", role: .destructive) { dismiss() }
                Button("Seguir editando", role: .cancel) { }
            } message: {
                Text("Tienes cambios sin guardar.")
            }
            .sheet(isPresented: $showingColorPicker) {
                ColorPickerView(selectedColorId: $selectedColorId)
            }
            .sheet(isPresented: $showingCategoryPicker) {
                CategoryPickerView(selectedCategoryId: $selectedCategory)
            }
            .overlay {
                if viewModel.isLoading {
                    LoadingOverlay()
                }
            }
        }
        .interactiveDismissDisabled(hasUnsavedChanges)
        .onAppear(perform: setupInitialState)
    }
    
    // MARK: - UI Components
    
    private var titleField: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("Título", text: $title)
                .font(.title2)
                .fontWeight(.semibold)
                .focused($isTitleFocused)
                .submitLabel(.next)
                .onSubmit { isContentFocused = true }
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.horizontal, 20)
        }
    }
    
    private var contentField: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextEditor(text: $content)
                .font(.body)
                .focused($isContentFocused)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .frame(minHeight: 200)
                .padding(.horizontal, 16)
        }
    }
    
    // ✅ MEJORA: Sección de personalización optimizada
    private var customizationSection: some View {
        VStack(spacing: 16) {
            Divider()
                .padding(.horizontal, 20)
            
            // Selector de color usando el modelo
            HStack {
                Text("Color")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Button(action: { showingColorPicker = true }) {
                    HStack(spacing: 8) {
                        colorIndicator
                        Text(selectedColorModel?.name ?? "Predeterminado")
                            .font(.subheadline)
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .foregroundColor(.primary)
            }
            .padding(.horizontal, 20)
            
            // Selector de categoría usando el modelo
            HStack {
                Text("Categoría")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Button(action: { showingCategoryPicker = true }) {
                    HStack(spacing: 8) {
                        Text(selectedCategoryModel?.icon ?? "📄")
                            .font(.system(size: 16))
                        Text(selectedCategoryModel?.name ?? "General")
                            .font(.subheadline)
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .foregroundColor(.primary)
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
        .background(Color(.systemBackground).opacity(0.7))
        .cornerRadius(12)
        .padding(.horizontal, 20)
    }
    
    // ✅ MEJORA: Indicador de color usando el modelo
    private var colorIndicator: some View {
        Group {
            if selectedColorId == "default" {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color(.systemGray4), lineWidth: 1)
                    .frame(width: 20, height: 20)
            } else {
                Circle()
                    .fill(selectedColorModel?.color ?? .clear)
                    .frame(width: 20, height: 20)
            }
        }
    }
    
    // ✅ MEJORA: Barra de herramientas usando el modelo
    private var createNoteToolbar: some View {
        HStack(spacing: 20) {
            Button(action: { showingColorPicker = true }) {
                Image(systemName: "paintpalette")
                    .font(.title3)
                    .foregroundColor(.primary)
            }
            
            Button(action: { showingCategoryPicker = true }) {
                Image(systemName: "folder")
                    .font(.title3)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            // Indicador de color actual usando el modelo
            if selectedColorId != "default" {
                Circle()
                    .fill(selectedColorModel?.color ?? .clear)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Circle()
                            .stroke(Color(.systemBackground), lineWidth: 2)
                    )
            }
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.systemBackground).opacity(0.95))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 34)
    }
    
    // ✅ MEJORA: Fondo dinámico usando el modelo
    private var noteBackgroundColor: some View {
        let baseColor = selectedColorModel?.color ?? .clear
        return LinearGradient(
            gradient: Gradient(colors: [
                baseColor.opacity(0.08),
                Color(.systemGroupedBackground)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // MARK: - Logic Methods
    
    // ✅ MEJORA: Validaciones mejoradas
    private var canSave: Bool {
        let hasTitle = !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let hasContent = !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        return hasTitle || hasContent
    }

    private var hasUnsavedChanges: Bool {
        !title.isEmpty ||
        !content.isEmpty ||
        selectedCategory != "default" ||
        selectedColorId != "default"
    }
    
    private func setupInitialState() {
        selectedCategory = "default"
        selectedColorId = "default"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isTitleFocused = true
        }
    }
    
    private func handleCancel() {
        if hasUnsavedChanges {
            showingDiscardAlert = true
        } else {
            dismiss()
        }
    }

    // ✅ MEJORA: Método de guardado optimizado
    private func saveNote() {
        Task {
            // ✅ Crear el request usando el modelo
            let noteRequest = CreateNoteRequest(
                title: title.isEmpty ? "Sin título" : title,
                content: content,
                categoryId: selectedCategory,
                colorId: selectedColorId == "default" ? nil : selectedColorId
            )
            
            let success = await viewModel.createNote(
                title: noteRequest.title,
                content: noteRequest.content,
                categoryId: noteRequest.categoryId,
                colorId: noteRequest.colorId
            )
            
            if success {
                dismiss()
            }
        }
    }
}

// MARK: - Supporting Views

struct LoadingOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3).ignoresSafeArea()
            ProgressView("Guardando...")
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(radius: 5)
        }
    }
}
