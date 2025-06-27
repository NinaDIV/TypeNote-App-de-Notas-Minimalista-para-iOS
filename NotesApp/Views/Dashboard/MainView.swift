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
    
    // MARK: - Constants
    private let categories = NoteCategory.categories
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Header Premium
                MainHeaderView(
                    showCreateView: $showCreateView,
                    showProfileView: $showProfileView
                )
                .environmentObject(viewModel)
                .background(
                    // Fondo con gradiente radial sutil
                    RadialGradient(
                        colors: [
                            Color(.systemBackground),
                            Color(.systemGray6).opacity(0.2)
                        ],
                        center: .topLeading,
                        startRadius: 50,
                        endRadius: 300
                    )
                )
                .overlay(
                    // Línea separadora elegante
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [.clear, .primary.opacity(0.06), .clear],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 0.5)
                        .opacity(0.8),
                    alignment: .bottom
                )
                
                // Barra de búsqueda integrada con navegación
                SearchBarView(
                    searchText: $searchText,
                    selectedCategory: $selectedCategory,
                    categories: categories
                )
                .environmentObject(viewModel)
                .background(Color(.systemBackground))
                
                // Contenido principal con padding
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Contenido de notas
                        contentView
                            .padding(.horizontal, 24)
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 32)
                }
                .background(
                    // Fondo con patrón de papel
                    PaperPatternBackground()
                        .opacity(0.3)
                )
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(for: String.self) { noteId in
            NoteDetailView(noteId: noteId)
                .environmentObject(viewModel)
                .navigationBarHidden(true) // 👈 MUY IMPORTANTE

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
            LoadingStateView()
        } else if filteredNotes.isEmpty {
            EmptyStateView(
                showCreateView: $showCreateView,
                showProfileView: $showProfileView
            )
            .environmentObject(viewModel)
            .transition(.opacity.combined(with: .scale(scale: 0.95)))
        } else {
            // Grid de notas mejorado
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                ForEach(filteredNotes, id: \.id) { note in
                    NoteCardView(note: note) {
                        handleNoteSelection(note.id)
                    }
                    .environmentObject(viewModel)
                }
            }
            .transition(.opacity.combined(with: .move(edge: .bottom)))
        }
    }
    
    // MARK: - Computed Properties
    private var filteredNotes: [Note] {
        let allNotes = viewModel.notes
        
        guard selectedCategory != nil || !searchText.isEmpty else {
            return allNotes.sorted { $0.createdAt > $1.createdAt }
        }
        
        var result = allNotes
        
        if let category = selectedCategory {
            result = result.filter { note in
                category == "recent" ? note.isRecent : note.categoryId == category
            }
        }
        
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

// MARK: - Paper Pattern Background
struct PaperPatternBackground: View {
    var body: some View {
        VStack(spacing: 32) {
            ForEach(0..<25, id: \.self) { _ in
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                .primary.opacity(Double.random(in: 0.01...0.02)),
                                .clear,
                                .primary.opacity(Double.random(in: 0.01...0.02))
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 0.8)
                    .opacity(Double.random(in: 0.3...0.8))
            }
        }
    }
}

// MARK: - Loading State Component
struct LoadingStateView: View {
    @State private var isAnimating = false
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ], spacing: 16) {
            ForEach(0..<6, id: \.self) { _ in
                SkeletonCard()
            }
        }
        .overlay(
            VStack {
                Spacer()
                Text("Cargando notas...")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                    .opacity(isAnimating ? 0.5 : 1.0)
                    .padding(.bottom, 40)
            }
        )
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
        RoundedRectangle(cornerRadius: 24)
            .fill(Color(.systemGray6).opacity(0.6))
            .frame(height: 200)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.clear,
                                Color.white.opacity(0.3),
                                Color.clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .offset(x: isShimmering ? 250 : -250)
                    .animation(
                        .linear(duration: 1.8)
                        .repeatForever(autoreverses: false),
                        value: isShimmering
                    )
            )
            .clipped()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0...0.5)) {
                    isShimmering = true
                }
            }
    }
}

#Preview {
    NavigationStack {
        MainView(navigationPath: .constant(NavigationPath()))
            .environmentObject(NotesViewModel())
    }
}
