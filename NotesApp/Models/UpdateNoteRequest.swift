//
//  UpdateNoteRequest.swift
//  NotesApp
//
//  Created by Milward on 26/06/25.
//

import Foundation

struct UpdateNoteRequest: Codable {
    let noteId: String
    let title: String
    let content: String
    let categoryId: String
    let colorId: String?
}
