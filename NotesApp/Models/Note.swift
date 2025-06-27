import Foundation
import SwiftUI

struct Note: Codable, Identifiable {
    var id: String { noteId }

    let userId: String
    let noteId: String
    var title: String
    var content: String
    var categoryId: String
    var colorId: String?
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

    var categoryName: String {
        return NoteCategory.getCategory(by: categoryId)?.name ?? "General"
    }

    var categoryIcon: String {
        return NoteCategory.getCategory(by: categoryId)?.icon ?? "📄"
    }

    var categoryColor: Color {
        return NoteCategory.getCategory(by: categoryId)?.color ?? .gray
    }

    var noteColor: Color {
        guard let colorId = colorId else { return .clear }
        return NoteColorOption.getColor(by: colorId)?.color ?? .clear
    }

    var contentPreview: String {
        let maxLength = 120
        return content.count <= maxLength ? content : String(content.prefix(maxLength)) + "..."
    }

    var isRecent: Bool {
        let isoFormatter = ISO8601DateFormatter()
        guard let createdDate = isoFormatter.date(from: createdAt) else { return false }
        let dayAgo = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        return createdDate > dayAgo
    }

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

    var readingTime: String {
        let wordsPerMinute = 200
        let wordCount = content.split(separator: " ").count
        let minutes = max(1, wordCount / wordsPerMinute)
        return "\(minutes) min de lectura"
    }
}
