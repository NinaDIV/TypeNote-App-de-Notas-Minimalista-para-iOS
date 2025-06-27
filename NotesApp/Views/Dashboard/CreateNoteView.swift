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
    
    // ✅ NUEVO: Color principal dinámico como en NoteCardView
    private var primaryColor: Color {
        if let colorModel = selectedColorModel, selectedColorId != "default" {
            return colorModel.color
        }
        return selectedCategoryModel?.color ?? .blue
    }
    
    // ✅ NUEVO: Verifica si tiene color personalizado
    private var hasCustomColor: Bool {
        return selectedColorId != "default"
    }

    var body: some View {
        NavigationView {
            ZStack {
                // ✅ MEJORA: Fondo con gradiente más elegante como NoteCardView
                noteBackgroundColor
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 28) {
                        // ✅ MEJORA: Header visual con indicadores
                        headerSection
                        
                        // Campo de título mejorado
                        titleField
                        
                        // Campo de contenido mejorado
                        contentField
                        
                        
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 120)
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
                    .foregroundColor(canSave ? primaryColor : .secondary)
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
    
    // ✅ NUEVO: Header visual con indicadores como NoteCardView
    private var headerSection: some View {
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
            
            // Indicador "Nuevo" como en NoteCardView
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
        .padding(.horizontal, 24)
    }
    
    private var titleField: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Título de la nota", text: $title)
                .font(.system(size: 22, weight: .semibold))
                .focused($isTitleFocused)
                .submitLabel(.next)
                .onSubmit { isContentFocused = true }
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
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
        }
        .padding(.horizontal, 20)
    }
    
    private var contentField: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .topLeading) {
                // Placeholder mejorado
                if content.isEmpty {
                    Text("Escribe aquí el contenido de tu nota...")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .allowsHitTesting(false)
                }
                
                TextEditor(text: $content)
                    .font(.system(size: 16))
                    .focused($isContentFocused)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .frame(minHeight: 220)
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
        }
        .padding(.horizontal, 20)
    }
    
     
    
    // ✅ NUEVO: Row component reutilizable para personalización
    private func customizationRow<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
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
    
    // ✅ MEJORA: Indicador de color mejorado como NoteCardView
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
    
    // ✅ MEJORA: Barra de herramientas más elegante
    private var createNoteToolbar: some View {
        HStack(spacing: 24) {
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
            
            // Indicador de estado actual
            HStack(spacing: 12) {
                if hasCustomColor {
                    Circle()
                        .fill(primaryColor)
                        .frame(width: 12, height: 12)
                        .shadow(color: primaryColor.opacity(0.4), radius: 2, x: 0, y: 1)
                        .overlay(
                            Circle()
                                .stroke(Color(.systemBackground), lineWidth: 2)
                        )
                }
                
                Text(selectedCategoryModel?.name ?? "General")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(primaryColor)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(primaryColor.opacity(0.1))
                    )
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
        // Feedback háptico como en NoteCardView
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
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
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.2)
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                
                Text("Guardando...")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 32)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 6)
            )
        }
    }
}
