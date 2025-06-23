//
//  NotesViewModel.swift
//  NotesApp
//
//  Created by Milward on 21/06/25.
//
import Foundation
import Amplify

@MainActor
class NotesViewModel: ObservableObject {
   // MARK: - Published Properties
   @Published var notes: [Note] = []
   @Published var isLoading = false
   @Published var errorMessage = ""
   @Published var isSignedIn = false
   @Published var currentUser: String = ""
   @Published var currentUserName: String = ""
   
   // MARK: - Auth Methods
   func signUp(email: String, password: String) async {
       isLoading = true
       clearError()
       
       do {
           let result = try await Amplify.Auth.signUp(
               username: email,
               password: password,
               options: AuthSignUpRequest.Options(userAttributes: [
                   AuthUserAttribute(.email, value: email)
               ])
           )
           print("✅ SignUp result: \(result)")
       } catch {
           errorMessage = "Error en registro: \(error.localizedDescription)"
           print("❌ SignUp error: \(error)")
       }
       
       isLoading = false
   }
   
   func confirmSignUp(email: String, code: String) async {
       isLoading = true
       clearError()
       
       do {
           let result = try await Amplify.Auth.confirmSignUp(
               for: email,
               confirmationCode: code
           )
           print("✅ Confirmación exitosa: \(result)")
       } catch {
           errorMessage = "Error confirmando: \(error.localizedDescription)"
           print("❌ Confirm error: \(error)")
       }
       
       isLoading = false
   }
   
   func signIn(email: String, password: String) async {
       isLoading = true
       clearError()
       
       do {
           let result = try await Amplify.Auth.signIn(
               username: email,
               password: password
           )
           
           if result.isSignedIn {
               isSignedIn = true
               currentUser = email
               loadUserName()
               await loadNotes()
               print("✅ Login exitoso")
           }
       } catch {
           errorMessage = "Error en login: \(error.localizedDescription)"
           print("❌ SignIn error: \(error)")
       }
       
       isLoading = false
   }
   
   func signOut() async {
       do {
           let result = try await Amplify.Auth.signOut()
           print("✅ SignOut: \(result)")
           
           // Reset state
           isSignedIn = false
           currentUser = ""
           notes = []
           clearError()
       } catch {
           errorMessage = "Error cerrando sesión: \(error.localizedDescription)"
           print("❌ SignOut error: \(error)")
       }
   }
   
   func checkAuthStatus() async {
       do {
           let session = try await Amplify.Auth.fetchAuthSession()
           isSignedIn = session.isSignedIn
           
           if isSignedIn {
               let user = try await Amplify.Auth.getCurrentUser()
               currentUser = user.username
               loadUserName()
               await loadNotes()
           }
       } catch {
           print("❌ Error verificando auth: \(error)")
           isSignedIn = false
       }
   }
   
   // MARK: - Notes Methods
   func loadNotes() async {
       isLoading = true
       clearError()
       
       do {
           let request = RESTRequest(path: "/notes")
           let data = try await Amplify.API.get(request: request)
           
           if let notesResponse = try? JSONDecoder().decode(NotesResponse.self, from: data) {
               notes = notesResponse.notes
           } else {
               notes = try JSONDecoder().decode([Note].self, from: data)
           }
           
           print("✅ Cargadas \(notes.count) notas")
       } catch {
           errorMessage = "Error cargando notas: \(error.localizedDescription)"
           print("❌ Load notes error: \(error)")
       }
       
       isLoading = false
   }
   
   // ✅ ACTUALIZADO: Función para crear nota con soporte para colores
   func createNote(title: String, content: String, categoryId: String = "default", colorId: String? = nil) async -> Bool {
       guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
           errorMessage = "El título no puede estar vacío"
           return false
       }
       
       isLoading = true
       clearError()
       
       do {
           let noteRequest = CreateNoteRequest(
               title: title.trimmingCharacters(in: .whitespacesAndNewlines),
               content: content.trimmingCharacters(in: .whitespacesAndNewlines),
               categoryId: categoryId,
               colorId: colorId == "default" ? nil : colorId // ✅ Enviar nil si es default
           )
           let requestData = try JSONEncoder().encode(noteRequest)
           
           let request = RESTRequest(
               path: "/notes",
               headers: ["Content-Type": "application/json"],
               body: requestData
           )
           
           let _ = try await Amplify.API.post(request: request)
           await loadNotes()
           print("✅ Nota creada exitosamente")
           
           isLoading = false
           return true
       } catch {
           errorMessage = "Error creando nota: \(error.localizedDescription)"
           print("❌ Create note error: \(error)")
           
           isLoading = false
           return false
       }
   }
   
   // ✅ ACTUALIZADO: Función para actualizar nota con soporte para colores
   func updateNote(noteId: String, title: String, content: String, categoryId: String = "default", colorId: String? = nil) async -> Bool {
       guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
           errorMessage = "El título no puede estar vacío"
           return false
       }
       
       isLoading = true
       clearError()
       
       do {
           let updateRequest = UpdateNoteRequest(
               noteId: noteId,
               title: title.trimmingCharacters(in: .whitespacesAndNewlines),
               content: content.trimmingCharacters(in: .whitespacesAndNewlines),
               categoryId: categoryId,
               colorId: colorId == "default" ? nil : colorId // ✅ Enviar nil si es default
           )
           let requestData = try JSONEncoder().encode(updateRequest)
           
           let request = RESTRequest(
               path: "/notes/\(noteId)",
               headers: ["Content-Type": "application/json"],
               body: requestData
           )
           
           let _ = try await Amplify.API.put(request: request)
           await loadNotes()
           print("✅ Nota actualizada exitosamente")
           
           isLoading = false
           return true
       } catch {
           errorMessage = "Error actualizando nota: \(error.localizedDescription)"
           print("❌ Update note error: \(error)")
           
           isLoading = false
           return false
       }
   }
   
   func deleteNote(noteId: String) async {
       isLoading = true
       clearError()
       
       do {
           let request = RESTRequest(path: "/notes/\(noteId)")
           let _ = try await Amplify.API.delete(request: request)
           
           notes.removeAll { $0.noteId == noteId }
           print("✅ Nota eliminada exitosamente")
       } catch {
           errorMessage = "Error eliminando nota: \(error.localizedDescription)"
           print("❌ Delete note error: \(error)")
       }
       
       isLoading = false
   }
   
   // MARK: - Helper Methods
   func clearError() {
       errorMessage = ""
   }
   
   func refreshNotes() async {
       await loadNotes()
   }
   
   func getNote(by noteId: String) -> Note? {
       return notes.first { $0.noteId == noteId }
   }
   
   func getNotes(by categoryId: String) -> [Note] {
       return notes.filter { $0.categoryId == categoryId }
   }
   
   // MARK: - User Profile Methods
   func loadUserName() {
       if let savedName = UserDefaults.standard.string(forKey: "user_full_name"), !savedName.isEmpty {
           currentUserName = savedName
       } else {
           let components = currentUser.components(separatedBy: "@")
           currentUserName = components.first?.capitalized ?? "Usuario"
       }
   }
   
   func saveUserName(_ name: String) {
       let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
       guard !trimmedName.isEmpty else { return }
       
       currentUserName = trimmedName
       UserDefaults.standard.set(trimmedName, forKey: "user_full_name")
       print("✅ Nombre guardado: \(trimmedName)")
   }
   
   func getUserInitials() -> String {
       let components = currentUserName.components(separatedBy: " ")
       let initials = components.compactMap { $0.first }.prefix(2)
       return String(initials).uppercased()
   }
}
