//
//  Note.swift
//  NotesApp
//
//  Created by Milward on 21/06/25.
//

import Foundation
import SwiftUI

// MARK: - Modelo principal de nota
struct Note: Codable, Identifiable {
    var id: String { noteId }

    let userId: String
    let noteId: String
    var title: String
    var content: String
    var categoryId: String
    var colorId: String? // ✅ Agregado para soportar colores
    let createdAt: String
    var updatedAt: String

    enum CodingKeys: String, CodingKey {
        case userId, noteId, title, content, categoryId, colorId, createdAt, updatedAt
    }

    var formattedDate: String {
        let isoFormatter = ISO8601DateFormatter()
        if let date = isoFormatter.date(from: createdAt) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .short
            return displayFormatter.string(from: date)
        }
        return createdAt
    }
    
    // MARK: - Extensiones para UI estilo Notion
    var categoryName: String {
        return NoteCategory.getCategory(by: categoryId)?.name ?? "General"
    }
    
    var categoryIcon: String {
        return NoteCategory.getCategory(by: categoryId)?.icon ?? "📄"
    }
    
    var categoryColor: Color {
        return NoteCategory.getCategory(by: categoryId)?.color ?? .gray
    }
    
    // ✅ Color personalizado de la nota
    var noteColor: Color {
        guard let colorId = colorId else { return .clear }
        switch colorId {
        case "red": return .red
        case "orange": return .orange
        case "yellow": return .yellow
        case "green": return .green
        case "blue": return .blue
        case "purple": return .purple
        case "pink": return .pink
        case "gray": return .gray
        default: return .clear
        }
    }
    
    // Preview del contenido para las tarjetas
    var contentPreview: String {
        let maxLength = 120
        if content.count <= maxLength {
            return content
        }
        return String(content.prefix(maxLength)) + "..."
    }
    
    // Indica si la nota fue creada recientemente (últimas 24 horas)
    var isRecent: Bool {
        let isoFormatter = ISO8601DateFormatter()
        guard let createdDate = isoFormatter.date(from: createdAt) else { return false }
        let dayAgo = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        return createdDate > dayAgo
    }
    
    // Formato de fecha más amigable
    var relativeDate: String {
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: createdAt) else { return createdAt }
        
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(date) {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return "Hoy a las " + formatter.string(from: date)
        } else if calendar.isDateInYesterday(date) {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return "Ayer a las " + formatter.string(from: date)
        } else if calendar.dateInterval(of: .weekOfYear, for: now)?.contains(date) == true {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            return formatter.string(from: date)
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
    }
    
    // Tiempo de lectura estimado
    var readingTime: String {
        let wordsPerMinute = 200
        let wordCount = content.split(separator: " ").count
        let minutes = max(1, wordCount / wordsPerMinute)
        return "\(minutes) min de lectura"
    }
}

// MARK: - Modelo para crear nota
struct CreateNoteRequest: Codable {
    let title: String
    let content: String
    let categoryId: String
    let colorId: String? // ✅ Agregado soporte para color
}

// MARK: - Modelo para actualizar nota
struct UpdateNoteRequest: Codable {
    let noteId: String
    let title: String
    let content: String
    let categoryId: String
    let colorId: String? // ✅ Agregado soporte para color
}

// MARK: - Respuesta para lista de notas
struct NotesResponse: Codable {
    let notes: [Note]
    let message: String?
}

// MARK: - Respuesta para una sola nota
struct NoteResponse: Codable {
    let note: Note
    let message: String
}

// MARK: - Estructura para categorías con colores integrados
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
        return categories.filter { $0.id != "recent" } // Excluir "recent" de la lista general
    }
}

// MARK: - Estructura para colores de notas
struct NoteColorOption {
    let id: String
    let name: String
    let color: Color
    
    static let colors = [
        NoteColorOption(id: "default", name: "Predeterminado", color: .clear),
        NoteColorOption(id: "red", name: "Rojo", color: .red),
        NoteColorOption(id: "orange", name: "Naranja", color: .orange),
        NoteColorOption(id: "yellow", name: "Amarillo", color: .yellow),
        NoteColorOption(id: "green", name: "Verde", color: .green),
        NoteColorOption(id: "blue", name: "Azul", color: .blue),
        NoteColorOption(id: "purple", name: "Morado", color: .purple),
        NoteColorOption(id: "pink", name: "Rosa", color: .pink),
        NoteColorOption(id: "gray", name: "Gris", color: .gray)
    ]
    
    static func getColor(by id: String) -> NoteColorOption? {
        return colors.first { $0.id == id }
    }
    
    static func getAllColors() -> [NoteColorOption] {
        return colors
    }
}
