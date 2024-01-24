//
//  CreateBlock.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/17/24.
//

import SwiftUI

struct CreateBlock: View {
    // MARK: - Properties
    // MARK: State Properties
    @State private var offset: CGSize = .zero
    
    // MARK: Binding Properties
    @Binding var isDragging: Bool
    @Binding var dragEvent: DragEvent
    
    // MARK: - Body
    var body: some View {
        GeometryReader { proxy in
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
            .offset(offset)
            .makeDraggable(
                isDragging: $isDragging,
                dragEvent: $dragEvent,
                origin: proxy.frame(in: .global).origin
            )
        }
        .frame(width: 120, height: 60)
        
        .onChange(of: dragEvent.translation, { oldValue, newValue in
            if isDragging {
                offset = dragEvent.translation
            }
        })
        .onChange(of: isDragging, { oldValue, newValue in
            withAnimation(.snappy) {
                if !isDragging {
                    offset = isDragging ? dragEvent.translation : .zero
                }
            }
        })
    }
}

#Preview {
    CreateBlock(isDragging: .constant(false), dragEvent: .constant(DragEvent(absoluteOrigin: .zero)))
}
