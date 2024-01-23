//
//  HomeView.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/22/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    // MARK: - Properties
    // MARK: Environment Properties
    @Environment (\.modelContext) private var context
    // MARK: State Properties
    @Query private var clusters: [Cluster]
    @State private var isDragging: Bool = false
    @State private var draggedTask: Task? = nil
    @State private var draggedCellZIndex: Double = 0
    @State private var clusterForDraggedCellZIndex: Double = 0
    @State private var clusterForDraggedCell: Cluster?
    @State private var draggedCellEvent = DragEvent(absoluteOrigin: .zero)
    @State private var draggedCreateBlockEvent = DragEvent(absoluteOrigin: .zero)
    @State private var selectedCluster: Cluster?
    @State private var selectedAction: Action?
    @State private var editingTask = Task(name: "", symbol: nil, date: Date(), minuteGroup: .zeroToTen)
    @State private var isEditing: Bool = false
    @State private var cellReorder: CellReorder?
    @State private var isShowingTaskView = false
    @State private var shouldCreateNewTask = false
    @State private var newTask: Task = Task.empty()
    
    private var orderedClusters: [Cluster] {
        clusters.sorted(by: { $0.minuteGroup.rawValue < $1.minuteGroup.rawValue })
    }
    
    private func task(id: String) -> Task? {
        orderedClusters.flatMap({ $0.tasks }).filter({ $0.id == id }).first ?? nil
    }
    
    private func indexPath(forTask task: Task) -> IndexPath? {
        for sectionIndex in 0..<orderedClusters.count {
            let cluster = orderedClusters[sectionIndex]
            for itemIndex in 0..<cluster.tasks.count {
                let enumeratedTask = cluster.tasks[itemIndex]
                if enumeratedTask == task {
                    return IndexPath(item: itemIndex, section: sectionIndex)
                }
            }
        }
        return nil
    }
    
    private func indexPath(forCluster cluster: Cluster) -> IndexPath? {
        for index in 0..<orderedClusters.count {
            let enumeratedCluster = orderedClusters[index]
            if enumeratedCluster == cluster {
                return IndexPath(item: 0, section: index)
            }
        }
        return nil
    }
    
    // MARK: - Task Handling
    private func handleReorder(_ reorder: CellReorder) {
        // Move within same section
        if reorder.originClusterId == reorder.finalClusterId {
            guard let originClusterIndex = orderedClusters.firstIndex(where: { $0.id == reorder.originClusterId }) else { return }
            guard reorder.originIndex < orderedClusters[originClusterIndex].tasks.count else { return }
            guard reorder.finalIndex <= orderedClusters[originClusterIndex].tasks.count && reorder.finalIndex >= 0 else { return }
            let task = orderedClusters[originClusterIndex].tasks[reorder.originIndex]
            withAnimation {
                orderedClusters[originClusterIndex].move(task: task, to: reorder.finalIndex)
                self.cellReorder = nil
            }
        }
        
        // Move to new section
        if reorder.originClusterId != reorder.finalClusterId,
           clusterForDraggedCell != selectedCluster {
            guard let draggedTask else { return }
            guard let selectedCluster else { return }
            move(task: draggedTask, toCluster: selectedCluster)
            self.selectedCluster = nil
            self.cellReorder = nil
        }
    }
    
    private func handleAction(_ action: Action) {
        guard let draggedTask else { return }
        switch action.id {
        case ActionType.edit.rawValue: edit(draggedTask)
        case ActionType.duplicate.rawValue: duplicate(draggedTask)
        case ActionType.delete.rawValue: delete(draggedTask)
        default: break
        }
        self.selectedAction = nil
        self.selectedCluster = nil
    }
    
    // MARK: - Data Handling
    private func edit(_ task: Task) {
        editingTask = task
        withAnimation {
            isEditing = true
        }
    }
    
    private func duplicate(_ task: Task) {
        guard let indexPath = indexPath(forTask: task) else { return }
        let newTask = Task.duplicate(task)
        withAnimation {
            orderedClusters[indexPath.section].insert(newTask, at: indexPath.item + 1)
        }
    }
    
    private func delete(_ task: Task) {
        guard let indexPath = indexPath(forTask: task) else { return }
        guard indexPath.section < orderedClusters.count else { return }
        withAnimation {
            orderedClusters[indexPath.section].remove(task)
        }
    }
    
    // MARK: - Task Reordering
    private func add(task: Task, toCluster cluster: Cluster) {
        // Continues only if the task id does not already exist.
        // This allows new tasks to share the same name, but not the same id.
        guard indexPath(forTask: task) == nil else { return }
        guard orderedClusters.contains(where: { $0 == cluster }) else { return }
        guard let indexPath = indexPath(forCluster: cluster) else { return }
        orderedClusters[indexPath.section].add(task)
    }
    
    private func move(task: Task, toCluster cluster: Cluster) {
        guard clusterForDraggedCell != cluster else { return }
        withAnimation(.snappy) {
            delete(task)
            add(task: task, toCluster: cluster)
        }
    }
    
    private func replace(task originalTask: Task, withTask newTask: Task) {
        guard let indexPath = indexPath(forTask: originalTask) else { return }
        orderedClusters[indexPath.section].replace(task: originalTask, withTask: newTask)
    }
    
    // MARK: - Views
    private var header: some View {
        HStack {
            Text("\(Date().timeString)")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            Spacer()
        }
    }
    
    private var list: some View {
        VStack {
            ForEach(orderedClusters) { cluster in
                ClusterView(
                    cluster: cluster,
                    isDragging: $isDragging,
                    draggedTask: $draggedTask,
                    draggedCellZIndex: $draggedCellZIndex,
                    clusterForDraggedCell: $clusterForDraggedCell,
                    clusterForDraggedCellZIndex: $clusterForDraggedCellZIndex,
                    draggedCellEvent: $draggedCellEvent,
                    selectedCluster: $selectedCluster,
                    selectedAction: $selectedAction,
                    cellReorder: $cellReorder
                )
                .zIndex(clusterForDraggedCell == cluster ? clusterForDraggedCellZIndex : 0.0)
                .onTouch(
                    dragEvent: $draggedCellEvent,
                    offset: CGPoint(x: 16, y: -16),
                    id: cluster.id,
                    dragInsideCallback: nil,
                    changeCallback: { isInside in
                        if isInside {
                            selectedCluster = cluster
                        } else if selectedCluster == cluster {
                            selectedCluster = nil
                        }
                    }
                )
                .onTouch(
                    dragEvent: $draggedCreateBlockEvent,
                    offset: CGPoint(x: 16, y: -16),
                    id: cluster.id,
                    dragInsideCallback: nil,
                    changeCallback: { isInside in
                        if isInside {
                            selectedCluster = cluster
                        } else if selectedCluster == cluster {
                            selectedCluster = nil
                        }
                    }
                )
                .onTouchUpGesture {
                    guard let selectedAction else { return }
                    handleAction(selectedAction)
                }
                .onChange(of: cellReorder) { oldValue, newValue in
                    guard let cellReorder else { return }
                    handleReorder(cellReorder)
                }
                .onChange(of: isShowingTaskView) { oldValue, newValue in
                    if !isShowingTaskView {
                        selectedCluster = nil
                    }
                }
            }
        }
    }
    
    // MARK: - Body
    var body: some View {
        if isEditing {
            EditTaskView(task: $editingTask, isEditing: $isEditing)
                .transition(.scale)
        } else {
            GeometryReader { proxy in
                VStack {
                    header
                    ScrollView {
                        VStack {
                            list
                        }
                    }
                    CreateBlock(isDragging: $isDragging, dragEvent: $draggedCreateBlockEvent)
                        .onTouchUpGesture {
                            if selectedCluster != nil {
                                newTask = Task.empty()
                                newTask.minuteGroup = selectedCluster?.minuteGroup ?? .zeroToTen
                                isShowingTaskView = true
                            }
                        }
                }
                .onAppear {
                    let zIndex = orderedClusters.flatMap({ $0.tasks }).count - 1
                    draggedCellZIndex = Double(zIndex)
                    clusterForDraggedCellZIndex = Double(zIndex)
                    draggedCellEvent = DragEvent(absoluteOrigin: proxy.frame(in: .global).origin)
                    draggedCreateBlockEvent = DragEvent(absoluteOrigin: proxy.frame(in: .global).origin)
                }
            }
            .sheet(isPresented: $isShowingTaskView, content: {
                TaskView(
                    showSymbolPicker: false,
                    isEditing: false,
                    clusterTask: $newTask,
                    isShowingTaskView: $isShowingTaskView,
                    shouldCreateNewTask: $shouldCreateNewTask
                )
            })
            .onAppear {
                if orderedClusters.isEmpty {
                    context.insert(Cluster(hour: Date().hour(), minuteGroup: .zeroToTen, tasks: []))
                    context.insert(Cluster(hour: Date().hour(), minuteGroup: .tenToTwenty, tasks: []))
                    context.insert(Cluster(hour: Date().hour(), minuteGroup: .twentyToThirty, tasks: []))
                    context.insert(Cluster(hour: Date().hour(), minuteGroup: .thirtyToForty, tasks: []))
                    context.insert(Cluster(hour: Date().hour(), minuteGroup: .fortyToFifty, tasks: []))
                    context.insert(Cluster(hour: Date().hour(), minuteGroup: .fiftyToSixty, tasks: []))
                }
            }
            .onChange(of: isShowingTaskView, { oldValue, newValue in
                if !isShowingTaskView, shouldCreateNewTask {
                    guard !newTask.name.isEmpty || !(newTask.symbol ?? "").isEmpty else { return }
                    print("name: \(newTask.name), symbol: \(newTask.symbol ?? "")")
                    clusters.filter({ $0.minuteGroup == newTask.minuteGroup }).first?.add(newTask)
                    newTask = Task.empty()
                }
            })
        }
    }
}

#Preview {
    HomeView()
}
