//
//  NavigationSectionView.swift
//  NotesApp
//
//  Created by Milward on 22/06/25.
//

import SwiftUI

struct NavigationSectionView: View {
    @EnvironmentObject var viewModel: NotesViewModel
    @Binding var isNavigationCollapsed: Bool
    @Binding var selectedCategory: String?
    let categories: [NoteCategory]
    
    // Estado interno que controla el retardo del contenido
    @State private var showNavigationContent: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Botón de navegación
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isNavigationCollapsed.toggle()
                }
                
                if isNavigationCollapsed {
                    showNavigationContent = false
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        withAnimation(.easeInOut) {
                            showNavigationContent = true
                        }
                    }
                }
            }) {
                HStack {
                    Text("Navegación")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: isNavigationCollapsed ? "chevron.down" : "chevron.up")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Contenido visible con retardo
            if showNavigationContent {
                VStack(alignment: .leading, spacing: 8) {
                    NavigationItemView(
                        icon: "doc.text",
                        title: "Todas las notas",
                        count: viewModel.notes.count,
                        isSelected: selectedCategory == nil
                    ) {
                        selectedCategory = nil
                    }
                    
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(height: 1)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                    
                    HStack {
                        Text("Categorías")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Image(systemName: "plus")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 4)
                    
                    ForEach(categories, id: \.id) { category in
                        let notesCount = category.id == "recent" ?
                            viewModel.notes.filter { $0.isRecent }.count :
                            viewModel.notes.filter { $0.categoryId == category.id }.count
                        
                        if notesCount > 0 || category.id == "recent" {
                            NavigationItemView(
                                icon: category.icon,
                                title: category.name,
                                count: notesCount,
                                isSelected: selectedCategory == category.id
                            ) {
                                selectedCategory = category.id
                            }
                        }
                    }
                }
                .padding(.bottom, 16)
                .transition(.opacity.combined(with: .slide))
            }
        }
        .onAppear {
            // Asegurar que arranca retraído
            isNavigationCollapsed = true
            showNavigationContent = false
        }
        .background(Color(.systemGray6).opacity(0.3))
    }
}
