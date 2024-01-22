//
//  SectionHeader.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/22/24.
//

import SwiftUI

struct SectionHeader: View {
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
        }
        .frame(height: 64)
        .padding(.horizontal, 20)
    }
}

#Preview {
    SectionHeader(title: "Section")
}
