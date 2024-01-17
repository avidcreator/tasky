//
//  NowView.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/17/24.
//

import SwiftUI

struct NowView: View {
    @State private var dragLocation: CGPoint = .zero
    @State var minuteGroupSelected: String? = nil
    @State var isShowingTaskView: Bool = false
    
    private var allTasks: [Task] = []
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
    
    private var minuteGroupViews: some View {
        VStack {
            ForEach(MinuteGroup.allCases, id: \.id) { minuteGroup in
                if let tasks = tasks[minuteGroup] {
                    MinuteGroupView(
                        hour: Date().hour,
                        minuteGroup: minuteGroup,
                        tasks: tasks,
                        minuteGroupSelected: $minuteGroupSelected,
                        isHighlighted: minuteGroup == Date().minuteGroup
                    )
                    .opacity(minuteGroup.rawValue != Date().minuteGroup.rawValue ? 0.3 : 1.0)
                    .background {
                        dragDetector(for: minuteGroup)
                    }
                }
            }
        }
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
                ScrollViewReader { proxy in
                    ScrollView {
                        minuteGroupViews
                        Spacer()
                    }
                    .onAppear {
                        proxy.scrollTo(Date().minuteGroup.id, anchor: .top)
                    }
                }
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
