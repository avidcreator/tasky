//
//  CreateBlock.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/17/24.
//

import SwiftUI

struct CreateBlock: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.white)
                .frame(width: 120, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 1)
            Image(systemName: "plus")
                .resizable()
                .frame(width: 18, height: 18)
                .foregroundStyle(Color(.darkGray))
        }
    }
}

#Preview {
    CreateBlock()
}
