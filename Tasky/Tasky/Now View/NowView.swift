//
//  NowView.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/17/24.
//

import SwiftUI
import SwiftData

struct NowView: View {
    @State private var dragLocation: CGPoint = .zero
    @State var minuteGroupSelected: String? = nil
    @State var isShowingTaskView: Bool = false
    
    @Query private var allTasks: [Task] = []
    var dayTasks: [Task] {
        allTasks.filter({ $0.date.isSameDayAs(date: Date()) })
    }
    
    private var tasks: [MinuteGroup: [Task]] {
        var tasks: [MinuteGroup: [Task]] = [:]
        for minuteGroup in MinuteGroup.allCases {
            var minuteGroupTasks: [Task] = []
            for dayTask in dayTasks {
                if dayTask.minuteGroup == minuteGroup {
                    minuteGroupTasks.append(dayTask)
                }
            }
            tasks[minuteGroup] = minuteGroupTasks
        }
        return tasks
    }
    
    private var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                let screenHeight = UIScreen.main.bounds.size.height
                let targetYPosition = screenHeight - 155
                guard value.startLocation.y > targetYPosition else { return }
                self.dragLocation = value.location
            }
            .onEnded { value in
                self.dragLocation = .zero
                if minuteGroupSelected != nil {
                    isShowingTaskView = true
                }
            }
    }
    
    private var draggableBlock: some View {
        Block.empty(isHighlighted: .constant(false))
            .opacity(dragLocation != .zero ? 1.0 : 0.0)
            .position(dragLocation)
    }
    
    private func dragDetector(for minuteGroup: MinuteGroup) -> some View {
        GeometryReader { proxy in
            let proxyFrame = proxy.frame(in: .global)
            let yOffset = 50.0
            let frame = CGRect(
                x: proxyFrame.origin.x,
                y: proxyFrame.origin.y - yOffset,
                width: proxyFrame.width,
                height: proxyFrame.height)
            let isDragLocationInsideFrame = frame.contains(dragLocation)
            let isDragLocationInsideRectangle = isDragLocationInsideFrame &&
            Rectangle().path(in: frame).contains(dragLocation)
            Color.clear
                .onChange(of: isDragLocationInsideRectangle) { oldValue, newValue in
                    print(dragLocation)
                    print("isDragLocationInsideFrame: \(isDragLocationInsideFrame)")
                    if dragLocation != .zero, isDragLocationInsideFrame {
                        minuteGroupSelected = minuteGroup.id
                    } else {
                        // TODO: - Handle clearing minuteGroupSelected
                    }
                }
        }
    }
    
    private func list(minuteGroups: [MinuteGroup]) -> some View {
        List {
            ForEach(minuteGroups, id: \.id) { minuteGroup in
                let isMinuteGroupActive = minuteGroup == Date().minuteGroup
                Section {
                    if let tasks = tasks[minuteGroup] {
                        ForEach(tasks) { task in
                            BlockCell(name: task.name, symbol: task.symbol, isHighlighted: isMinuteGroupActive)
                            .background {
                                Rectangle()
                                    .fill(Color(minuteGroupSelected == minuteGroup.id ? .systemGray6 : .clear))
                                dragDetector(for: minuteGroup)
                            }
                            .opacity(isMinuteGroupActive ? 1.0 : 0.3)
                        }
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                } header: {
                    MinuteGroupSectionView(hour: Date().hour(), minuteGroup: minuteGroup, isBolded: isMinuteGroupActive)
                    .background {
                        Rectangle()
                            .fill(Color(minuteGroupSelected == minuteGroup.id ? .systemGray6 : .clear))
                        dragDetector(for: minuteGroup)
                    }
                }
            }
            .onMove { from, to in
                // TODO: move the data source.
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("\(Date().timeString)")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    Spacer()
                }
                list(minuteGroups: MinuteGroup.allCases)
                Spacer()
                CreateBlock()
                    .opacity(dragLocation == .zero ? 1.0 : 0.0)
            }
            draggableBlock
        }
        .statusBar(hidden: true)
        .gesture(drag)
        .sheet(isPresented: $isShowingTaskView, content: {
            let task = Task(
                name: "",
                symbol: nil,
                date: Date(),
                minuteGroup: MinuteGroup.make(id: minuteGroupSelected ?? "") ?? .zeroToTen
            )
            TaskView(
                task: task,
                showSymbolPicker: false,
                isShowingTaskView: $isShowingTaskView,
                minuteGroupSelected: $minuteGroupSelected,
                isEditing: false
            )
        })
    }
}

#Preview {
    return NowView()
}
