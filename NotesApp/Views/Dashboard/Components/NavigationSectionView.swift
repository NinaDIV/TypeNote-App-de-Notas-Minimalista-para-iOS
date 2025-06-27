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
    
    @State private var showNavigationContent: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header de navegación
            Button(action: {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isNavigationCollapsed.toggle()
                }
                
                if isNavigationCollapsed {
                    showNavigationContent = false
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showNavigationContent = true
                        }
                    }
                }
            }) {
                HStack {
                    Text("Navegación")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: isNavigationCollapsed ? "chevron.down" : "chevron.up")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                        .rotationEffect(.degrees(isNavigationCollapsed ? 0 : 180))
                        .animation(.easeInOut(duration: 0.2), value: isNavigationCollapsed)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Contenido de navegación
            if showNavigationContent {
                VStack(alignment: .leading, spacing: 6) {
                    NavigationItemView(
                        icon: "doc.text",
                        title: "Todas las notas",
                        count: viewModel.notes.count,
                        isSelected: selectedCategory == nil
                    ) {
                        selectedCategory = nil
                    }
                    
                    // Separador elegante
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [.clear, .primary.opacity(0.08), .clear],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 0.8)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                    
                    // Header de categorías
                    HStack {
                        Text("Categorías")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                            .tracking(0.5)
                        
                        Spacer()
                        
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 6)
                    
                    // Lista de categorías
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
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6).opacity(0.4))
        )
        .onAppear {
            isNavigationCollapsed = true
            showNavigationContent = false
        }
    }
}
