//
//  SectionHeader.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/22/24.
//

import SwiftUI

struct SectionHeader: View {
    // MARK: - Properties
    var title: String
    @State var isBolded = false
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(isBolded ? .black : .gray)
                .font(isBolded ? .title2 : .headline)
                .fontWeight(isBolded ? .bold : .regular)
            Spacer()
        }
        .frame(height: 64)
        .padding(.horizontal, 20)
    }
}

#Preview {
    SectionHeader(title: "Section")
}
