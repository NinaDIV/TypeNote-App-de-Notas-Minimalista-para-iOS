//
//  CreateNoteRequest.swift
//  NotesApp
//
//  Created by Milward on 26/06/25.
//

import Foundation

struct CreateNoteRequest: Codable {
    let title: String
    let content: String
    let categoryId: String
    let colorId: String?
}
