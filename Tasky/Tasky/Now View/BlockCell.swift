//
//  BlockCell.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/17/24.
//

import SwiftUI

struct BlockCell: View {
    var name: String
    var symbol: String?
    @State var isHighlighted: Bool
    
    var body: some View {
        HStack {
            Block(name: name, symbol: symbol, isHighlighted: $isHighlighted)
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
}

#Preview {
    BlockCell(name: "Go on a walk", symbol: "walk", isHighlighted: false)
}
