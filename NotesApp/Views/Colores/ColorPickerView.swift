//
//  ColorPickerView.swift
//  NotesApp
//
//  Created by Milward on 22/06/25.
//

import SwiftUI

struct ColorPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedColorId: String
    
    private let colors: [(id: String, name: String, color: Color)] = [
        ("default", "Predeterminado", .clear),
        ("red", "Rojo", .red),
        ("orange", "Naranja", .orange),
        ("yellow", "Amarillo", .yellow),
        ("green", "Verde", .green),
        ("blue", "Azul", .blue),
        ("purple", "Morado", .purple),
        ("pink", "Rosa", .pink),
        ("gray", "Gris", .gray)
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Elige un color")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Personaliza el aspecto de tu nota")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 24)
                
                // Grid de colores
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3), spacing: 24) {
                    ForEach(colors, id: \.id) { colorOption in
                        ColorOptionView(
                            colorId: colorOption.id,
                            colorName: colorOption.name,
                            color: colorOption.color,
                            isSelected: selectedColorId == colorOption.id
                        ) {
                            selectedColorId = colorOption.id
                            dismiss()
                        }
                    }
                }
                .padding(.horizontal, 32)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ColorOptionView: View {
    let colorId: String
    let colorName: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    // Círculo de color o placeholder para default
                    if colorId == "default" {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(.systemGray4), lineWidth: 2, antialiased: true)
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: "paintbrush.pointed")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                            )
                    } else {
                        Circle()
                            .fill(color)
                            .frame(width: 60, height: 60)
                    }
                    
                    // Indicador de selección
                    if isSelected {
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                            .frame(width: 70, height: 70)
                            .overlay(
                                Circle()
                                    .stroke(Color.blue, lineWidth: 2)
                                    .frame(width: 74, height: 74)
                            )
                    }
                }
                
                Text(colorName)
                    .font(.caption)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundColor(isSelected ? .blue : .primary)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ColorPickerView(selectedColorId: .constant("blue"))
}
