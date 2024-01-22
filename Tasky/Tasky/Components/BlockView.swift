//
//  BlockView.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/22/24.
//

import SwiftUI

struct BlockView: View {
    // MARK: - Properties
    private enum Constants {
        static let scaleUpRatio = 1.15
        static let scaleNormalRatio = 1.0
    }
    
    var task: Task
    
    // MARK: State Properties
    @State private var scale = 1.0
    @State private var opacity: Double = 1.0
    @State private var offset: CGSize = .zero
    @State private var text: String = ""
    
    // MARK: Binding Properties
    @Binding var isDragging: Bool
    @Binding var dragEvent: DragEvent
    @Binding var animatesBackToOrigin: Bool
    
    // MARK: - Body
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                HStack {
                    Text(task.name)
                        .padding()
                }
                TextField(task.name, text: $text)
                    .fixedSize()
            }
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.2), radius: 6)
            }
            .opacity(opacity)
            .offset(offset)
            .makeDraggable(
                isDragging: $isDragging,
                dragEvent: $dragEvent,
                origin: proxy.frame(in: .global).origin
            )
            .onTouchDownGesture {
                withAnimation {
                    scale = Constants.scaleUpRatio
                }
            }
            .onTouchUpGesture {
                withAnimation {
                    scale = Constants.scaleNormalRatio
                }
            }
            .scaleEffect(scale)
            .onAppear {
                dragEvent = DragEvent(absoluteOrigin: proxy.frame(in: .global).origin)
            }
            .onChange(of: dragEvent.translation, { oldValue, newValue in
                if isDragging {
                    offset = dragEvent.translation
                }
            })
            .onChange(of: isDragging, { oldValue, newValue in
                if animatesBackToOrigin {
                    withAnimation(.snappy) {
                        if !isDragging {
                            offset = isDragging ? dragEvent.translation : .zero
                        }
                    }
                }
            })
        }
    }
}

#Preview {
    BlockView(
        task: Task(name: "Go on a walk", symbol: nil, date: Date(), minuteGroup: .zeroToTen),
        isDragging: .constant(false),
        dragEvent: .constant(DragEvent(absoluteOrigin: .zero)),
        animatesBackToOrigin: .constant(true)
    )
}
