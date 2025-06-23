//
//  NavigationItemView.swift
//  NotesApp
//
//  Created by Milward on 22/06/25.
//

import SwiftUI

struct NavigationItemView: View {
    let icon: String
    let title: String
    let count: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if icon.count == 1 {
                    Text(icon)
                        .font(.system(size: 16))
                        .frame(width: 24, height: 24)
                } else {
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .frame(width: 24, height: 24)
                        .foregroundColor(isSelected ? .blue : .primary)
                }
                
                Text(title)
                    .font(.system(size: 15))
                    .foregroundColor(isSelected ? .blue : .primary)
                
                Spacer()
                
                if count > 0 {
                    Text("\(count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(isSelected ? Color.blue.opacity(0.1) : Color.clear)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
