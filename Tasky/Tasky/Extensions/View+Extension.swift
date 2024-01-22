//
//  View+Extension.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/22/24.
//

import SwiftUI

extension View {
    func onTouchDownGesture(callback: @escaping () -> Void) -> some View {
        modifier(OnTouchDownGestureModifier(callback: callback))
    }
    
    func onTouchUpGesture(callback: @escaping () -> Void) -> some View {
        modifier(OnTouchUpGestureModifier(callback: callback))
    }
    
    func makeDraggable(
        isDragging: Binding<Bool>,
        dragEvent: Binding<DragEvent>,
        origin: CGPoint
    ) -> some View {
        modifier(
            MakeDraggableModifier(isDragging: isDragging, event: dragEvent, origin: origin)
        )
    }
    
    func onTouch(
        dragEvent: Binding<DragEvent>,
        offset: CGPoint,
        id: String,
        dragInsideCallback: ((CGPoint, CGPoint) -> Void)?,
        changeCallback: ((Bool) -> Void)?
    ) -> some View {
        modifier(
            OnTouch(
                offset: offset,
                id: id,
                dragInsideCallback: dragInsideCallback,
                changeCallback: changeCallback,
                dragEvent: dragEvent
            )
        )
    }
}

private struct OnTouchDownGestureModifier: ViewModifier {
    @State private var tapped = false
    let callback: () -> Void

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !self.tapped {
                        self.tapped = true
                        self.callback()
                    }
                }
                .onEnded { _ in
                    self.tapped = false
                })
    }
}

private struct OnTouchUpGestureModifier: ViewModifier {
    @State private var tapped = false
    let callback: () -> Void

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !self.tapped {
                        self.tapped = true
                    }
                }
                .onEnded { _ in
                    self.tapped = false
                    self.callback()
                })
    }
}

private struct MakeDraggableModifier: ViewModifier {
    @Binding var isDragging: Bool
    @Binding var event: DragEvent
    var origin: CGPoint
    
    private func dragGesture() -> some Gesture {
        DragGesture()
            .onChanged { gesture in
                event.translation = gesture.translation
                event.absoluteLocation = CGPoint(
                    x: origin.x + gesture.startLocation.x + gesture.translation.width,
                    y: origin.y + gesture.startLocation.y + gesture.translation.height
                )
                event.relativeLocation = CGPoint(
                    x: gesture.startLocation.x + gesture.translation.width,
                    y: gesture.startLocation.y + gesture.translation.height
                )
                if !isDragging {
                    isDragging = true
                }
            }
            .onEnded { gesture in
                isDragging = false
                withAnimation {
                    event.translation = .zero
                    event.absoluteLocation = .zero
                    event.relativeLocation = .zero
                }
            }
    }
    
    func body(content: Content) -> some View {
        content.gesture(dragGesture())
    }
}

private struct OnTouch: ViewModifier {
    // MARK: - Properties
    var offset: CGPoint
    let id: String
    let dragInsideCallback: ((CGPoint, CGPoint) -> Void)?
    let changeCallback: ((Bool) -> Void)?
    
    // MARK: Binding Properties
    @Binding var dragEvent: DragEvent
    
    // MARK: - Handling
    private func handleTranslation(frame: CGRect, isInside: Bool) {
        guard isInside else { return }
        let xDifference = dragEvent.absoluteLocation.x - frame.origin.x
        let yDifference = dragEvent.absoluteLocation.y - frame.origin.y
        let xProgress = abs((frame.origin.x - dragEvent.absoluteLocation.x) / frame.size.width)
        let yProgress = 1.0 - abs((frame.origin.y - dragEvent.absoluteLocation.y) / frame.size.height)
        self.dragInsideCallback?(
            CGPoint(x: xDifference, y: yDifference),
            CGPoint(x: xProgress, y: yProgress)
        )
    }
    
    private func handleIsInside(_ isInside: Bool) {
        if dragEvent.absoluteLocation != .zero {
            self.changeCallback?(isInside)
        }
    }
    
    // MARK: - Body
    func body(content: Content) -> some View {
        content.background {
            GeometryReader { proxy in
                // add any offsets if needed
                let frame = CGRect(
                    x: proxy.frame(in: .global).origin.x - offset.x,
                    y: proxy.frame(in: .global).origin.y - offset.y,
                    width: proxy.frame(in: .global).width,
                    height: proxy.frame(in: .global).height
                )
                
                // check if frame contains absolute drag location
                let rectanglePath = Rectangle().path(in: frame)
                let isInside = frame.contains(dragEvent.absoluteLocation) && rectanglePath.contains(dragEvent.absoluteLocation)
                
                Color.clear
                    .onChange(of: dragEvent.translation, { oldValue, newValue in
                        handleTranslation(frame: frame, isInside: isInside)
                    })
                    .onChange(of: isInside) { oldValue, newValue in
                        handleIsInside(isInside)
                    }
            }
        }
    }
}
