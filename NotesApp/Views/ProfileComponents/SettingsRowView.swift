//
//  SettingsRowView.swift
//  NotesApp
//
//  Created by Milward on 22/06/25.
//

import SwiftUI

struct SettingsRowView: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        Button(action: {
            // Implementar acción específica para cada configuración
        }) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
                    .frame(width: 24, alignment: .center)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
