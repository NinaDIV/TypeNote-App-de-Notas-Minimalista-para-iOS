//
//  ProfileConfigView.swift
//  NotesApp
//
//  Created by Milward on 22/06/25.
//

import SwiftUI

struct ProfileConfigView: View {
    @EnvironmentObject var viewModel: NotesViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var userName: String = ""
    @State private var showingLogoutAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Header del perfil
                    ProfileHeaderView(userName: $userName, dismiss: dismiss)
                        .environmentObject(viewModel)
                    
                    // Resumen de actividad
                    ActivitySummaryView()
                        .environmentObject(viewModel)
                    
                    // Configuraciones
                    SettingsView()
                    
                    // Acciones peligrosas
                    DangerousActionsView(showingLogoutAlert: $showingLogoutAlert)
                        .environmentObject(viewModel)
                }
                .padding(20)
            }
            .navigationTitle("Mi Perfil")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            userName = viewModel.currentUserName
        }
    }
} 
