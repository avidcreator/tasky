//
//  SymbolView.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/17/24.
//

import SwiftUI

enum SymbolStyle {
    case normal
    case highlighted
}

enum SymbolSize: Double {
    case small = 24.0
    case medium = 56.0
    case large = 80.0
}

struct SymbolView: View {
    var systemName: String
    var size: SymbolSize
    var style: SymbolStyle = .normal
    private let cornerRadiusRatio = 0.5
    
    private var padding: Double {
        switch size {
        case .small: return 12
        case .medium: return 28
        case .large: return 40
        }
    }
    
    private var cornerRadius: Double {
        switch size {
        case .small: return 12
        case .medium: return 28
        case .large: return 40
        }
    }
    
    private var backgroundColor: Color {
        switch style {
        case .normal: return Color(.clear)
        case .highlighted: return Color(.systemGray5)
        }
    }
    
    var body: some View {
        ZStack {
            Image(systemName: systemName)
                .resizable()
                .scaledToFit()
                .frame(width: size.rawValue, height: size.rawValue)
                .padding(padding)
                .foregroundStyle((Color.init(white: 0.2)))
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .tint(.black)
        }
    }
}

#Preview {
    SymbolView(systemName: "figure.pool.swim", size: .large)
}

