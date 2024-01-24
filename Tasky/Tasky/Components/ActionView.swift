//
//  ActionView.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/22/24.
//

import SwiftUI

struct ActionView: View {
    // MARK: - Properties
    
    // MARK: State Properties
    @State var action: Action
    @State var selectionTint: Color
    @State var selectionBackgroundTint: Color
    @State private var offset: CGSize = .zero
    @State private var scale: Double = 1.0
    
    // MARK: Binding Properties
    @Binding var isDragging: Bool
    @Binding var selectedAction: Action?
    @Binding var dragEvent: DragEvent
    @Binding var offsetProgress: CGPoint
    
    // MARK: Computed Properties
    private var isSelected: Bool {
        selectedAction == action
    }
    
    private var maxXOffset = 16.0
    private var xOffset: CGFloat { offsetProgress.x * maxXOffset }
    private var yOffset: CGFloat { dragEvent.translation.height - 56 }
    
    // MARK: - Init
    init(
        action: Action,
        isDragging: Binding<Bool>,
        selectedAction: Binding<Action?>,
        dragEvent: Binding<DragEvent>,
        offsetProgress: Binding<CGPoint>,
        selectionTint: Color? = nil,
        selectionBackgroundTint: Color? = nil
    ) {
        self.action = action
        self._isDragging = isDragging
        self._selectedAction = selectedAction
        self._dragEvent = dragEvent
        self._offsetProgress = offsetProgress
        self.selectionTint = selectionTint ?? .white
        self.selectionBackgroundTint = selectionBackgroundTint ?? (action.destructive ? .red : .black)
    }
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 0) {
            if let symbol = action.symbol {
                Image(systemName: symbol)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(isSelected ? selectionTint : .black)
                    .symbolRenderingMode(.monochrome)
            }
            if let title = action.title {
                Text(title)
                    .foregroundStyle(isSelected ? selectionTint : .gray)
                    .fontWeight(isSelected ? .bold : .regular)
                    .padding()
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(selectedAction == action ? selectionBackgroundTint.opacity(0.9) : Color(.systemGray5).opacity(0.7))
                .scaleEffect(scale, anchor: .top)
        }
        .offset(offset)
        .onChange(of: dragEvent.translation) { oldValue, newValue in
            withAnimation(Animation.smooth(duration: 0.3, extraBounce: 0.0)) {
                scale = isSelected ? 1.3 : 1.0
                offset = isSelected ? CGSize(width: xOffset - (maxXOffset / 2), height: yOffset) : .zero
            }
        }
    }
}

extension ActionView {
    func onActionTriggered(callback: @escaping () -> Void) -> some View {
        modifier(
            OnActionTriggerModifier(
                callback: callback,
                isSelected: selectedAction == action,
                isDragging: isDragging
            )
        )
    }
}

private struct OnActionTriggerModifier: ViewModifier {
    let callback: () -> Void
    let isSelected: Bool
    var isDragging: Bool
    
    func body(content: Content) -> some View {
        content
            .onChange(of: isDragging, { oldValue, newValue in
                if !isDragging, isSelected {
                    self.callback()
                }
            })
    }
}

#Preview {
    ActionView(
        action: Action.make(type: .edit),
        isDragging: .constant(false),
        selectedAction: .constant(nil),
        dragEvent: .constant(DragEvent(absoluteOrigin: .zero)),
        offsetProgress: .constant(.zero),
        selectionTint: .white,
        selectionBackgroundTint: .black
    )
}
