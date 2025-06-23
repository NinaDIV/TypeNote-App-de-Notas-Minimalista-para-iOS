//
//  AppInitializer.swift
//  NotesApp
//
//  Created by Milward on 21/06/25.
//

import Foundation
import Amplify
import AWSCognitoAuthPlugin
import AWSAPIPlugin

class AppInitializer: ObservableObject {
    @Published var isAmplifyConfigured = false
    @Published var configurationError: String?

    init() {
        configureAmplify()
    }

    func configureAmplify() {
        print("🔄 Iniciando configuración de Amplify...")

        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSAPIPlugin())
            try Amplify.configure()

            print("✅ Amplify configurado exitosamente")

            DispatchQueue.main.async {
                self.isAmplifyConfigured = true
            }

        } catch {
            print("❌ Error configurando Amplify: \(error)")
            DispatchQueue.main.async {
                self.configurationError = error.localizedDescription
            }
        }
    }
}
