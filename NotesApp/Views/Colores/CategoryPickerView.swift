//
//  CategoryPickerView.swift
//  NotesApp
//
//  Created by Milward on 22/06/25.
//
//
//  CategoryPickerView.swift
//  NotesApp
//
//  Created by Milward on 22/06/25.
//

import SwiftUI

struct CategoryPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedCategoryId: String
    
    private let availableCategories = NoteCategory.categories.filter { $0.id != "recent" }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Elige una categoría")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Organiza tu nota por tema")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 24)
                
                // Lista de categorías
                VStack(spacing: 12) {
                    ForEach(availableCategories, id: \.id) { category in
                        CategoryOptionView(
                            category: category,
                            isSelected: selectedCategoryId == category.id
                        ) {
                            selectedCategoryId = category.id
                            dismiss()
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CategoryOptionView: View {
    let category: NoteCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Ícono de categoría
                Text(category.icon)
                    .font(.title2)
                    .frame(width: 32, height: 32)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(category.name)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Text(getCategoryDescription(category.id))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color(.systemGray6).opacity(0.5))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue.opacity(0.3) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func getCategoryDescription(_ categoryId: String) -> String {
        switch categoryId {
        case "work":
            return "Notas relacionadas con el trabajo"
        case "personal":
            return "Notas personales y privadas"
        case "ideas":
            return "Ideas creativas y pensamientos"
        case "tasks":
            return "Tareas y recordatorios"
        case "default":
            return "Notas generales sin categoría específica"
        default:
            return ""
        }
    }
}

#Preview {
    CategoryPickerView(selectedCategoryId: .constant("work"))
}
