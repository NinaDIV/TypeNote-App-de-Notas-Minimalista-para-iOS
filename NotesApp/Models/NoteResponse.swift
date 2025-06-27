//
//  NoteResponse.swift
//  NotesApp
//
//  Created by Milward on 26/06/25.
//

import Foundation

struct NotesResponse: Codable {
    let notes: [Note]
    let message: String?
}

struct NoteResponse: Codable {
    let note: Note
    let message: String
}
