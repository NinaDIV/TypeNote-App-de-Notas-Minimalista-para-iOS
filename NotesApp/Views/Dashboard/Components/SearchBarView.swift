//
//  SearchBarView.swift
//  NotesApp
//
//  Created by Milward on 22/06/25.
//

import SwiftUI

struct SearchBarView: View {
    @EnvironmentObject var viewModel: NotesViewModel
    @Binding var searchText: String
    @Binding var selectedCategory: String?
    let categories: [NoteCategory]
    
    @State private var isFocused = false
    @State private var showCategoryDropdown = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Barra de búsqueda principal
            HStack {
                HStack(spacing: 12) {
                    // Botón de categoría
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showCategoryDropdown.toggle()
                        }
                    }) {
                        HStack(spacing: 6) {
                            if let categoryId = selectedCategory,
                               let category = categories.first(where: { $0.id == categoryId }) {
                                // Categoría seleccionada
                                if category.icon.count == 1 {
                                    Text(category.icon)
                                        .font(.system(size: 14, weight: .medium))
                                } else {
                                    Image(systemName: category.icon)
                                        .font(.system(size: 14, weight: .medium))
                                }
                                Text(category.name)
                                    .font(.system(size: 14, weight: .medium))
                                    .lineLimit(1)
                            } else {
                                // Todas las categorías
                                Image(systemName: "doc.text")
                                    .font(.system(size: 14, weight: .medium))
                                Text("Todas")
                                    .font(.system(size: 14, weight: .medium))
                            }
                            
                            Image(systemName: "chevron.down")
                                .font(.system(size: 10, weight: .medium))
                                .rotationEffect(.degrees(showCategoryDropdown ? 180 : 0))
                        }
                        .foregroundColor(.blue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.blue.opacity(0.1))
                        )
                    }
                    
                    // Separador
                    Rectangle()
                        .fill(Color(.systemGray4).opacity(0.6))
                        .frame(width: 1, height: 20)
                    
                    // Campo de búsqueda
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(isFocused ? .blue : .secondary)
                        .animation(.easeInOut(duration: 0.2), value: isFocused)
                    
                    TextField("Buscar notas...", text: $searchText)
                        .font(.system(size: 16, weight: .regular))
                        .textFieldStyle(PlainTextFieldStyle())
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isFocused = true
                            }
                        }
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isFocused = false
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.secondary)
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray6).opacity(0.6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(isFocused ? .blue.opacity(0.6) : .clear, lineWidth: 2)
                        )
                )
                .shadow(color: isFocused ? .blue.opacity(0.1) : .clear, radius: 8, x: 0, y: 4)
                .animation(.easeInOut(duration: 0.2), value: isFocused)
            }
            
            // Dropdown de categorías
            if showCategoryDropdown {
                VStack(spacing: 0) {
                    // Todas las notas
                    CategoryDropdownItem(
                        icon: "doc.text",
                        title: "Todas las notas",
                        count: viewModel.notes.count,
                        isSelected: selectedCategory == nil
                    ) {
                        selectedCategory = nil
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showCategoryDropdown = false
                        }
                    }
                    
                    // Separador
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(height: 1)
                        .padding(.horizontal, 16)
                    
                    // Categorías
                    ForEach(categories, id: \.id) { category in
                        let notesCount = category.id == "recent" ?
                            viewModel.notes.filter { $0.isRecent }.count :
                            viewModel.notes.filter { $0.categoryId == category.id }.count
                        
                        if notesCount > 0 || category.id == "recent" {
                            CategoryDropdownItem(
                                icon: category.icon,
                                title: category.name,
                                count: notesCount,
                                isSelected: selectedCategory == category.id
                            ) {
                                selectedCategory = category.id
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    showCategoryDropdown = false
                                }
                            }
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 8)
                )
                .padding(.top, 8)
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .scale(scale: 0.95, anchor: .top)),
                    removal: .opacity.combined(with: .scale(scale: 0.95, anchor: .top))
                ))
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 20)
        .zIndex(showCategoryDropdown ? 100 : 1) // Asegurar que el dropdown esté encima
    }
}

// MARK: - Category Dropdown Item
struct CategoryDropdownItem: View {
    let icon: String
    let title: String
    let count: Int
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            action()
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        }) {
            HStack(spacing: 12) {
                // Icono
                ZStack {
                    Circle()
                        .fill(isSelected ? .blue.opacity(0.15) : Color(.systemGray6))
                        .frame(width: 32, height: 32)
                    
                    if icon.count == 1 {
                        Text(icon)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(isSelected ? .blue : .secondary)
                    } else {
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(isSelected ? .blue : .secondary)
                    }
                }
                
                Text(title)
                    .font(.system(size: 15, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(isSelected ? .blue : .primary)
                
                Spacer()
                
                if count > 0 {
                    Text("\(count)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(.systemGray5).opacity(0.8))
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? .blue.opacity(0.05) : (isPressed ? Color(.systemGray6).opacity(0.5) : Color.clear))
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}
