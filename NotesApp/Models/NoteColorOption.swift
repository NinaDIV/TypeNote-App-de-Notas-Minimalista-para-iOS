//
//  NoteColorOption.swift
//  NotesApp
//
//  Created by Milward on 26/06/25.
//

import SwiftUI

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
