//
//  SettingsView.swift
//  NotesApp
//
//  Created by Milward on 22/06/25.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Configuración")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 1) {
                SettingsRowView(
                    icon: "bell.fill",
                    title: "Notificaciones",
                    subtitle: "Administrar recordatorios"
                )
                
                SettingsRowView(
                    icon: "icloud.fill",
                    title: "Sincronización",
                    subtitle: "Datos en la nube"
                )
                
                SettingsRowView(
                    icon: "lock.fill",
                    title: "Privacidad",
                    subtitle: "Seguridad y datos"
                )
                
                SettingsRowView(
                    icon: "questionmark.circle.fill",
                    title: "Ayuda y soporte",
                    subtitle: "Centro de ayuda"
                )
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray5), lineWidth: 0.5)
            )
        }
    }
}
