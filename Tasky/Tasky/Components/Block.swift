//
//  Block.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/17/24.
//

import SwiftUI

struct Block: View {
    var name: String
    var symbol: String?
    @Binding var isHighlighted: Bool
    
    static func empty(isHighlighted: Binding<Bool>) -> some View {
        Block(name: "", symbol: nil, isHighlighted: isHighlighted)
    }
    
    var body: some View {
        HStack {
            if let symbol {
                Image(systemName: symbol)
            }
            Text(name)
                .foregroundStyle(isHighlighted ? .white : .black)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .frame(minWidth: 90)
                .frame(height: 60)
        }
        .padding(.horizontal)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(isHighlighted ? .green : .white)
                .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 1)
        }
    }
}

#Preview {
    Block(name: "Complete a task", symbol: "list.bullet.clipboard", isHighlighted: .constant(false))
}
