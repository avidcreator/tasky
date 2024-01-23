//
//  TaskCell.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/22/24.
//

import SwiftUI

struct TaskCell: View {
    // MARK: - Properties
    var task: Task
    var actions: [Action] = [
        Action.make(type: .edit),
        Action.make(type: .duplicate),
        Action.make(type: .delete)
    ]
    
    // MARK: Binding Properties
    @Binding var isDragging: Bool
    @Binding var draggedTask: Task?
    @Binding var blockDragEvent: DragEvent
    @Binding var selectedAction: Action?
    @Binding var showsActions: Bool
    @Binding var cellPlacements: [String: CellPlacement]
    @Binding var isHighlighted: Bool
    
    // MARK: State Properties
    @State private var isDraggingBlock: Bool = false
    @State private var actionOpacity: Double = 0.0
    @State private var actionViewOffsetProgress: CGPoint = .zero
    @State private var blockViewAnimatesBackToOrigin = true
    @State private var offset: CGSize = .zero
    
    // MARK: Computed Properties
    private var isDraggingCell: Bool {
        draggedTask == task
    }
    
    // MARK: - Action Handling
    private func handleActionDragInside(progress: CGPoint) {
        // Controls the position offset of the view, making it appear wobbly and fun-like
        actionViewOffsetProgress = progress
    }
    
    private func handleActionDragChange(isInside: Bool, action: Action) {
        if isInside {
            // Select action when touch goes inside action view, if not already selected
            if draggedTask == task,
                selectedAction != action {
                selectedAction = action
                blockViewAnimatesBackToOrigin = action.id != ActionType.delete.rawValue
            }
        } else {
            // Deselect action when touch goes outside action view, if not already deselected
            if selectedAction != nil {
                selectedAction = nil
                blockViewAnimatesBackToOrigin = true
            }
        }
    }
    
    // MARK: - Block Handling
    private func updateDraggedTask(isDraggingBlock: Bool) {
        isDragging = isDraggingBlock
        if isDragging, draggedTask == nil {
            draggedTask = task
        }
        
        if draggedTask == task, !isDragging {
            draggedTask = nil
        }
    }
    
    private func updateActionOpacity(isDraggingCell: Bool) {
        withAnimation {
            actionOpacity = isDraggingCell ? 1.0 : 0.0
        }
    }
    
    private func updateOffset(forTaskId taskId: String) {
        // Move cell up or down when dragged over to communicate a cell reorder
        withAnimation {
            if let placement = cellPlacements[taskId] {
                offset = placement == .above ? CGSize(width: 0, height: -60) : CGSize(width: 0, height: 60)
            } else {
                offset = .zero
            }
        }
    }
    
    // MARK: - Action Views
    private var actionViews: some View {
        HStack {
            ForEach(actions) { action in
                ActionView(
                    action: action,
                    isDragging: $isDragging,
                    selectedAction: $selectedAction,
                    dragEvent: $blockDragEvent,
                    offsetProgress: $actionViewOffsetProgress
                )
                .onTouch(
                    dragEvent: $blockDragEvent,
                    offset: CGPoint(x: 16, y: 0),
                    id: task.name,
                    dragInsideCallback: { _, progress in
                        handleActionDragInside(progress: progress)
                    },
                    changeCallback: { isInside in
                        handleActionDragChange(isInside: isInside, action: action)
                    }
                )
            }
        }
    }
    
    // MARK: - Body
    var body: some View {
        GeometryReader { proxy in
            HStack {
                BlockView(
                    task: task,
                    isDragging: $isDraggingBlock,
                    dragEvent: $blockDragEvent,
                    animatesBackToOrigin: $blockViewAnimatesBackToOrigin,
                    isHighlighted: $isHighlighted
                )
                Spacer()
            }
            .padding(.horizontal, 16)
            .offset(offset)
            .background {
                HStack {
                    Spacer()
                    if showsActions {
                        actionViews
                    }
                }
                .opacity(actionOpacity)
                .padding(.trailing, 16)
            }
            .onAppear {
                blockDragEvent = DragEvent(absoluteOrigin: proxy.frame(in: .global).origin)
            }
            .onChange(of: isDraggingBlock) { oldValue, newValue in
                updateDraggedTask(isDraggingBlock: isDraggingBlock)
            }
            .onChange(of: isDraggingCell, { oldValue, newValue in
                updateActionOpacity(isDraggingCell: isDraggingCell)
            })
            .onChange(of: cellPlacements) { oldValue, newValue in
                updateOffset(forTaskId: task.id)
            }
        }
        .frame(height: 64)
    }
}

#Preview {
    TaskCell(
        task: Task(name: "Go on a walk", symbol: nil, date: Date(), minuteGroup: .zeroToTen),
        isDragging: .constant(false),
        draggedTask: .constant(nil),
        blockDragEvent: .constant(DragEvent(absoluteOrigin: .zero)),
        selectedAction: .constant(nil),
        showsActions: .constant(false),
        cellPlacements: .constant([:]),
        isHighlighted: .constant(false)
    )
}
