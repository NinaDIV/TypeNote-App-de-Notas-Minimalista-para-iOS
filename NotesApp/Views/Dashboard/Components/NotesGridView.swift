//
//  NotesGridView.swift
//  NotesApp
//
//  Created by Milward on 22/06/25.
//

import SwiftUI

struct NotesGridView: View {
    let notes: [Note]
    let onNoteSelected: (String) -> Void
    
    @EnvironmentObject var viewModel: NotesViewModel
    @State private var selectedNoteId: String?
    @State private var isRefreshing = false
    @State private var scrollOffset: CGFloat = 0
    
    // Grid configuration optimizada
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(Array(notes.enumerated()), id: \.element.id) { index, note in
                        NoteCardView(
                            note: note,
                            onTap: {
                                handleNoteSelection(note.noteId)
                            }
                        )
                        .environmentObject(viewModel)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .scale(scale: 0.8))
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.05)),
                            removal: .opacity.combined(with: .scale(scale: 0.8))
                                .animation(.easeInOut(duration: 0.3))
                        ))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
                .padding(.bottom, 32)
                .background(
                    // Fondo con patrón sutil
                    GridPatternBackground()
                        .opacity(0.02)
                )
            }
            .coordinateSpace(name: "scroll")
            .refreshable {
                await handleRefresh()
            }
            .overlay(
                // Indicador de carga durante refresh
                refreshIndicator,
                alignment: .top
            )
        }
     
        .background(
            // Fondo con gradiente muy sutil
            LinearGradient(
                colors: [
                    Color(.systemBackground),
                    Color(.systemGray6).opacity(0.1)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Refresh Indicator
    @ViewBuilder
    private var refreshIndicator: some View {
        if isRefreshing {
            HStack(spacing: 8) {
                ProgressView()
                    .scaleEffect(0.8)
                    .tint(.blue)
                
                Text("Actualizando notas...")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            .padding(.top, 8)
            .transition(.move(edge: .top).combined(with: .opacity))
        }
    }
    
    // MARK: - Helper Methods
    private func handleNoteSelection(_ noteId: String) {
        selectedNoteId = noteId
        
        // Feedback háptico
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        // Pequeño delay para mejor UX
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            onNoteSelected(noteId)
        }
    }
    
    private func handleRefresh() async {
        withAnimation(.easeInOut(duration: 0.3)) {
            isRefreshing = true
        }
        
        await viewModel.loadNotes()
        
        // Pequeño delay para mostrar el indicador
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 segundos
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isRefreshing = false
        }
    }
}

// MARK: - Grid Pattern Background
struct GridPatternBackground: View {
    var body: some View {
        VStack(spacing: 24) {
            ForEach(0..<20, id: \.self) { row in
                HStack(spacing: 24) {
                    ForEach(0..<10, id: \.self) { col in
                        Circle()
                            .fill(Color.primary.opacity(0.3))
                            .frame(width: 1, height: 1)
                    }
                }
            }
        }
    }
}

// MARK: - Empty State Component
struct EmptyNotesView: View {
    let onCreateNote: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            // Ilustración
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.blue.opacity(0.1),
                                Color.blue.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 48, weight: .light))
                    .foregroundColor(.blue.opacity(0.6))
            }
            
            VStack(spacing: 12) {
                Text("No hay notas aún")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("Crea tu primera nota para comenzar a organizar tus ideas")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            // Botón de acción
            Button(action: onCreateNote) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .semibold))
                    
                    Text("Crear primera nota")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        colors: [Color.blue, Color.blue.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: .blue.opacity(0.3), radius: 12, x: 0, y: 6)
            }
        }
        .padding(.top, 60)
    }
}

// MARK: - Preview
#Preview {
    let sampleNotes = [
        Note(
            userId: "user1",
            noteId: "1",
            title: "Reunión de trabajo",
            content: "Discutir los nuevos objetivos del proyecto y revisar el progreso actual.",
            categoryId: "work",
            colorId: nil,
            createdAt: ISO8601DateFormatter().string(from: Date()),
            updatedAt: ISO8601DateFormatter().string(from: Date())
        ),
        Note(
            userId: "user1",
            noteId: "2",
            title: "Ideas para el fin de semana",
            content: "Visitar el museo, hacer una caminata por el parque, probar ese nuevo restaurante.",
            categoryId: "personal",
            colorId: "blue",
            createdAt: ISO8601DateFormatter().string(from: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()),
            updatedAt: ISO8601DateFormatter().string(from: Date())
        ),
        Note(
            userId: "user1",
            noteId: "3",
            title: "Aplicación móvil innovadora",
            content: "Una app que combine productividad con gamificación para hacer las tareas diarias más divertidas.",
            categoryId: "ideas",
            colorId: nil,
            createdAt: ISO8601DateFormatter().string(from: Calendar.current.date(byAdding: .hour, value: -2, to: Date()) ?? Date()),
            updatedAt: ISO8601DateFormatter().string(from: Date())
        ),
        Note(
            userId: "user1",
            noteId: "4",
            title: "Lista de compras",
            content: "Leche, pan, huevos, frutas, verduras para la semana.",
            categoryId: "personal",
            colorId: "green",
            createdAt: ISO8601DateFormatter().string(from: Calendar.current.date(byAdding: .hour, value: -5, to: Date()) ?? Date()),
            updatedAt: ISO8601DateFormatter().string(from: Date())
        )
    ]
    
    Group {
        // Con notas
        NotesGridView(notes: sampleNotes) { noteId in
            print("Selected note: \(noteId)")
        }
        .environmentObject(NotesViewModel())
        
        // Sin notas (estado vacío)
        NotesGridView(notes: []) { noteId in
            print("Selected note: \(noteId)")
        }
        .environmentObject(NotesViewModel())
    }
}
