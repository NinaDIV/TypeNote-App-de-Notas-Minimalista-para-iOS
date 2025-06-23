//  MainView.swift
//  NotesApp
//
//  Created by Milward on 22/06/25.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: NotesViewModel
    @Binding var navigationPath: NavigationPath
    
    // MARK: - State Properties
    @State private var showCreateView = false
    @State private var showProfileView = false
    @State private var searchText = ""
    @State private var selectedCategory: String? = nil
    @State private var isNavigationCollapsed = true
    
    // MARK: - Constants
    private let categories = NoteCategory.categories
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // ✅ Header - Usando componente
                MainHeaderView(
                    showCreateView: $showCreateView,
                    showProfileView: $showProfileView
                )
                .environmentObject(viewModel)
                .headerBackground()
                
                // ✅ Barra de búsqueda - Usando componente
                SearchBarView(searchText: $searchText)
                
                // ✅ Contenido principal
                VStack(spacing: 0) {
                    // ✅ Navegación - Usando componente
                    NavigationSectionView(
                        isNavigationCollapsed: $isNavigationCollapsed,
                        selectedCategory: $selectedCategory,
                        categories: categories
                    )
                    .environmentObject(viewModel)
                    
                    // Divisor
                    Divider()
                        .background(Color(.separator).opacity(0.3))
                    
                    // ✅ Grid de notas - Usando componente
                    contentView
                        .contentBackground()
                }
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(for: String.self) { noteId in
            NoteDetailView(noteId: noteId)
                .environmentObject(viewModel)
        }
        .sheet(isPresented: $showCreateView) {
            CreateNoteView()
                .environmentObject(viewModel)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showProfileView) {
            ProfileConfigView()
                .environmentObject(viewModel)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .task {
            await loadInitialData()
        }
    }
    
    // MARK: - Content View
    @ViewBuilder
    private var contentView: some View {
        if viewModel.isLoading {
            // ✅ Componente de loading
            LoadingStateView()
        } else if filteredNotes.isEmpty {
            // ✅ Componente de estado vacío
            EmptyStateView(
                showCreateView: $showCreateView,
                showProfileView: $showProfileView
            )
            .environmentObject(viewModel)
            .transition(.opacity.combined(with: .scale(scale: 0.95)))
        } else {
            // ✅ Componente de grid
            NotesGridView(
                notes: filteredNotes,
                onNoteSelected: handleNoteSelection
            )
            .environmentObject(viewModel)
            .transition(.opacity.combined(with: .move(edge: .bottom)))
        }
    }
    
    // MARK: - Computed Properties
    private var filteredNotes: [Note] {
        let allNotes = viewModel.notes
        
        // Early return si no hay filtros
        guard selectedCategory != nil || !searchText.isEmpty else {
            return allNotes.sorted { $0.createdAt > $1.createdAt }
        }
        
        var result = allNotes
        
        // Filtrar por categoría
        if let category = selectedCategory {
            result = result.filter { note in
                category == "recent" ? note.isRecent : note.categoryId == category
            }
        }
        
        // Filtrar por búsqueda
        if !searchText.isEmpty {
            let searchLower = searchText.lowercased()
            result = result.filter { note in
                note.title.lowercased().contains(searchLower) ||
                note.content.lowercased().contains(searchLower)
            }
        }
        
        return result.sorted { $0.createdAt > $1.createdAt }
    }
    
    // MARK: - Helper Methods
    private func loadInitialData() async {
        guard viewModel.notes.isEmpty && !viewModel.isLoading else { return }
        await viewModel.loadNotes()
    }
    
    private func handleNoteSelection(_ noteId: String) {
        navigationPath.append(noteId)
    }
}

// MARK: - View Extensions
extension View {
    func headerBackground() -> some View {
        self
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(.systemBackground),
                        Color(.systemBackground).opacity(0.95)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
    }
    
    func contentBackground() -> some View {
        self
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(.systemBackground),
                        Color(.systemGroupedBackground).opacity(0.3)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
    }
}

// MARK: - View Modifiers (Optional - for reusability)
struct CreateNoteSheetModifier: ViewModifier {
    @Binding var isPresented: Bool
    let viewModel: NotesViewModel
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                CreateNoteView()
                    .environmentObject(viewModel)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
    }
}

struct ProfileSheetModifier: ViewModifier {
    @Binding var isPresented: Bool
    let viewModel: NotesViewModel
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                ProfileConfigView()
                    .environmentObject(viewModel)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
    }
}

// MARK: - Loading State Component
struct LoadingStateView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Grid de skeleton cards
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
                ForEach(0..<6, id: \.self) { _ in
                    SkeletonCard()
                }
            }
            .padding(.horizontal, 16)
            
            Text("Cargando notas...")
                .font(.caption)
                .foregroundColor(.secondary)
                .opacity(isAnimating ? 0.5 : 1.0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}

// MARK: - Skeleton Card Component
struct SkeletonCard: View {
    @State private var isShimmering = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(.systemGray6))
            .frame(height: 180)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.clear,
                                Color.white.opacity(0.4),
                                Color.clear
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .offset(x: isShimmering ? 300 : -300)
                    .animation(
                        .linear(duration: 1.5)
                        .repeatForever(autoreverses: false),
                        value: isShimmering
                    )
            )
            .clipped()
            .onAppear {
                isShimmering = true
            }
    }
}

#Preview {
    NavigationStack {
        MainView(navigationPath: .constant(NavigationPath()))
            .environmentObject(NotesViewModel())
    }
}
