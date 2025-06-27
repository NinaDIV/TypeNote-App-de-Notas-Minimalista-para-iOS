//
//  NoteCategory.swift
//  NotesApp
//
//  Created by Milward on 26/06/25.
//

import SwiftUI

struct NoteCategory {
    let id: String
    let name: String
    let icon: String
    let color: Color

    static let categories = [
        NoteCategory(id: "recent", name: "Recientes", icon: "📝", color: .blue),
        NoteCategory(id: "work", name: "Trabajo", icon: "💼", color: .blue),
        NoteCategory(id: "personal", name: "Personal", icon: "👤", color: .green),
        NoteCategory(id: "ideas", name: "Ideas", icon: "💡", color: .yellow),
        NoteCategory(id: "tasks", name: "Tareas", icon: "✅", color: .orange),
        NoteCategory(id: "study", name: "Estudio", icon: "📚", color: .purple),
        NoteCategory(id: "default", name: "General", icon: "📄", color: .gray)
    ]

    static func getCategory(by id: String) -> NoteCategory? {
        return categories.first { $0.id == id }
    }

    static func getAllCategories() -> [NoteCategory] {
        return categories.filter { $0.id != "recent" }
    }
}
