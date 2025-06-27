//
//  ActivitySummaryView.swift
//  NotesApp
//
//  Created by Milward on 22/06/25.
//
import SwiftUI

struct ActivitySummaryView: View {
    @EnvironmentObject var viewModel: NotesViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Resumen de actividad")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    // Total de notas
                    SummaryCardView(
                        icon: "doc.text.fill",
                        title: "Notas totales",
                        value: "\(viewModel.notes.count)",
                        color: .blue
                    )
                    
                    // Notas recientes
                    SummaryCardView(
                        icon: "clock.fill",
                        title: "Notas recientes",
                        value: "\(viewModel.notes.filter { $0.isRecent }.count)",
                        color: .green
                    )
                }
                
                HStack(spacing: 16) {
                    // Categorías usadas
                    SummaryCardView(
                        icon: "folder.fill",
                        title: "Categorías",
                        value: "\(Set(viewModel.notes.map { $0.categoryId }).count)",
                        color: .orange
                    )
                    
                    // Espacio usado (simulado)
                    SummaryCardView(
                        icon: "icloud.fill",
                        title: "Espacio usado",
                        value: "2.1 MB",
                        color: .purple
                    )
                }
            }
        }
    }
}
