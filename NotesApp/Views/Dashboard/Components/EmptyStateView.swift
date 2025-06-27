import SwiftUI

struct EmptyStateView: View {
    @EnvironmentObject var viewModel: NotesViewModel
    @Binding var showCreateView: Bool
    @Binding var showProfileView: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Icono principal
            Image(systemName: "note.text")
                .font(.system(size: 64))
                .foregroundColor(.secondary)
            
            // Texto principal
            VStack(spacing: 8) {
                Text("No hay notas")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text("Toca el botón + para crear tu primera nota")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Botón de acción
            Button(action: { showCreateView = true }) {
                HStack {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .medium))
                    Text("Crear nota")
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.blue)
                .cornerRadius(8)
            }
            
            Spacer()
        }
        .padding(.horizontal, 32)
    }
}
