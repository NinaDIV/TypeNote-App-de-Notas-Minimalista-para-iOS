//
//  NotesGridView.swift
//  NotesApp
//
//  Created by Milward on 22/06/25.
//

import SwiftUI

struct NotesGridView: View {
    let notes: [Note]
    let onNoteSelected: (String) -> Void // ✅ Callback para selección de nota
    
    @EnvironmentObject var viewModel: NotesViewModel
    @State private var selectedNoteId: String?
    
    // Grid configuration
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(notes) { note in
                    NoteCardView(
                        note: note,
                        onTap: {
                            // ✅ Llamar al callback cuando se toca una nota
                            onNoteSelected(note.noteId)
                        }
                    )
                    .environmentObject(viewModel)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .refreshable {
            await viewModel.loadNotes()
        }
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
        )
    ]
    
    NotesGridView(notes: sampleNotes) { noteId in
        print("Selected note: \(noteId)")
    }
    .environmentObject(NotesViewModel())
}
