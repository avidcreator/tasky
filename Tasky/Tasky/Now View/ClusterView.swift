//
//  ClusterView.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/22/24.
//

import SwiftUI

struct ClusterView: View {
    // MARK: - Properties
    // MARK: State Properties
    var cluster: Cluster
    @State private var backgroundColor = Color.clear
    @State private var showsActions = false
    @State private var draggedCellReleaseIndex: Int?
    @State private var cellPlacements: [String: CellPlacement] = [:]
    
    // MARK: Binding Properties
    @Binding var isDragging: Bool
    @Binding var draggedTask: Task?
    @Binding var draggedCellZIndex: Double
    @Binding var clusterForDraggedCell: Cluster?
    @Binding var clusterForDraggedCellZIndex: Double
    @Binding var draggedCellEvent: DragEvent
    @Binding var selectedCluster: Cluster?
    @Binding var selectedAction: Action?
    @Binding var cellReorder: CellReorder?
    
    // MARK: Computed Properties
    private var isCellDraggedFromSection: Bool { clusterForDraggedCell == cluster }
    private var isSelected: Bool { selectedCluster == cluster }
    
    // MARK: - Cell Placement
    private func addCellPlacementIfNeeded(taskId: String, originCellIndex: Int, overCellIndex: Int) {
        // These indices need to be different since, there's no point in moving
        // the cell if it's the dragged cell
        guard originCellIndex != overCellIndex else { return }
        let placement: CellPlacement = originCellIndex < overCellIndex ? .above : .below
        cellPlacements[taskId] = placement
    }
    
    private func removeCellPlacementIfNeeded(overCellIndex: Int) {
        // Identify all placements that need to be reset and add their keys to `removableKeys` for removal
        var removableKeys: [String] = []
        for taskId in cellPlacements.keys {
            let placement = cellPlacements[taskId]
            if let enumeratedIndex = cluster.tasks.firstIndex(where: { $0.id == taskId }) {
                let cellIsAboveAndNeedsResetting = placement == .above && overCellIndex < enumeratedIndex
                let cellIsBelowAndNeedsResetting = placement == .below && overCellIndex > enumeratedIndex
                if cellIsAboveAndNeedsResetting || cellIsBelowAndNeedsResetting {
                    removableKeys.append(taskId)
                }
            }
        }
        
        // Remove all placements that need to be reset
        for removableKey in removableKeys {
            cellPlacements.removeValue(forKey: removableKey)
        }
    }
    
    // MARK: - Drag Handling
    private func handleDraggedCellEventChange(isInside: Bool, task: Task) {
        guard let overCellIndex = cluster.index(ofTask: task) else { return }
        guard let draggedTask else { return }
        guard let originCellIndex = cluster.index(ofTask: draggedTask) else { return }
        
        // Restore original cell placement for cell underneath if it's no longer needed
        // to make the cell pop back into place when the dragged cell is no longer
        // interacting with it
        removeCellPlacementIfNeeded(overCellIndex: overCellIndex)
        
        // If the dragged cell interacts with the task, set the placement to either `.above` or `.below`
        addCellPlacementIfNeeded(taskId: task.id, originCellIndex: originCellIndex, overCellIndex: overCellIndex)
        
        // Update the index at which the dragged cell was released to handle further updates
        draggedCellReleaseIndex = overCellIndex
    }
    
    private func handleDragRelease() {
        guard let draggedTask else { return }
        guard let draggedCellReleaseIndex else { return }
        
        // Restore all cells back to their original placement
        cellPlacements.removeAll()
        
        // Update `cellReorder` with new placement of task
        if let originIndex = cluster.index(ofTask: draggedTask) {
            let finalIndexOffset = originIndex < draggedCellReleaseIndex ? 1 : 0
            cellReorder = CellReorder(
                originClusterId: cluster.id,
                finalClusterId: selectedCluster?.id ?? cluster.id,
                originIndex: originIndex,
                finalIndex: draggedCellReleaseIndex + finalIndexOffset
            )
        }
        
        // Reset release index for the dragged cell since it's been handled already
        self.draggedCellReleaseIndex = nil
    }
    
    // MARK: - Cluster Handling
    private func highlightClusterIfNeeded(isSelected: Bool) {
        if isSelected, clusterForDraggedCell != selectedCluster {
            backgroundColor = Color(.systemGray6).opacity(0.6)
        } else {
            backgroundColor = .clear
        }
    }
    
    private func updateClusterForDraggedCell() {
        if cluster.tasks.contains(where: { $0 == draggedTask }) {
            clusterForDraggedCell = cluster
        } else {
            if draggedTask == nil {
                clusterForDraggedCell = nil
            }
        }
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            VStack {
                let isMinuteGroupActive = cluster.minuteGroup == Date().minuteGroup
                SectionHeader(title: cluster.title, isBolded: isMinuteGroupActive)
                ForEach(cluster.tasks) { task in
                    TaskCell(
                        task: task,
                        isDragging: $isDragging,
                        draggedTask: $draggedTask,
                        blockDragEvent: $draggedCellEvent,
                        selectedAction: $selectedAction,
                        showsActions: $showsActions,
                        cellPlacements: $cellPlacements,
                        isHighlighted: isMinuteGroupActive
                    )
                    .onTouch(
                        dragEvent: $draggedCellEvent,
                        offset: CGPoint(x: 16, y: 16),
                        id: task.id,
                        dragInsideCallback: nil,
                        changeCallback: { isInside in
                            handleDraggedCellEventChange(isInside: isInside, task: task)
                        }
                    )
                    .zIndex(draggedTask == task ? draggedCellZIndex : 0)
                }
            }
        }
        .background(backgroundColor)
        
        // Set the current cluster for the dragged cell when `draggedTask` is updated
        .onChange(of: draggedTask) { oldValue, newValue in
            updateClusterForDraggedCell()
        }
        
        // Highlight cluster and unhighlight when selection changes
        .onChange(of: isSelected, { oldValue, newValue in
            highlightClusterIfNeeded(isSelected: isSelected)
        })
        
        // Update actions visibility when dragging starts or stops
        .onChange(of: isDragging) { oldValue, newValue in
            withAnimation {
                showsActions = cellPlacements.isEmpty
            }
        }
        
        // Hide actions when cell has been moved away
        // Show actions when cell has been moved back
        .onChange(of: cellPlacements) { oldValue, newValue in
            withAnimation {
                showsActions = cellPlacements.isEmpty
            }
        }
        
        // Update `cellReorder` when releasing a drag
        .onTouchUpGesture {
            handleDragRelease()
        }
    }
}

#Preview {
    ClusterView(
        cluster: SampleData.clusters.first ?? Cluster(hour: Date().hour(), minuteGroup: .zeroToTen, tasks: []),
        isDragging: .constant(false),
        draggedTask: .constant(nil),
        draggedCellZIndex: .constant(0.0),
        clusterForDraggedCell: .constant(nil),
        clusterForDraggedCellZIndex: .constant(0.0),
        draggedCellEvent: .constant(DragEvent(absoluteOrigin: .zero)),
        selectedCluster: .constant(nil),
        selectedAction: .constant(nil),
        cellReorder: .constant(nil)
    )
}
