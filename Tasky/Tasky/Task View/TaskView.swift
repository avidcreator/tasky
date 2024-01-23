//
//  TaskView.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/17/24.
//

import SwiftUI
import SymbolPicker

struct TaskView: View {
    // MARK: - Properties
    @State var showSymbolPicker: Bool
    @State var isEditing: Bool
    @State private var symbol: String?
    
    // MARK: Binding Properties
    @Binding var clusterTask: Task
    @Binding var isShowingTaskView: Bool
    @Binding var shouldCreateNewTask: Bool
    
    // MARK: - Initialization
    init(showSymbolPicker: Bool, isEditing: Bool, clusterTask: Binding<Task>, isShowingTaskView: Binding<Bool>, shouldCreateNewTask: Binding<Bool>) {
        self.showSymbolPicker = showSymbolPicker
        self.isEditing = isEditing
        self._clusterTask = clusterTask
        self._isShowingTaskView = isShowingTaskView
        self._shouldCreateNewTask = shouldCreateNewTask
    }
    
    // MARK: Views
    private var cancelButton: some View {
        Button("Cancel") {
            isShowingTaskView = false
            shouldCreateNewTask = false
        }
    }
    
    private var addButton: some View {
        Button {
            clusterTask.symbol = symbol
            isShowingTaskView = false
            shouldCreateNewTask = true
        } label: {
            Text("Add")
        }
    }
    
    private var form: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    Button {
                        showSymbolPicker = true
                    } label: {
                        SymbolView(symbol: $symbol, size: .medium, style: .highlighted)
                    }
                    .sheet(isPresented: $showSymbolPicker) {
                        SymbolPicker(symbol: $symbol)
                    }
                    Spacer()
                }
                NameView(placeholder: "name your task", name: $clusterTask.name)
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
        .navigationTitle(isEditing ? "Edit task" : "New task")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !isEditing {
                ToolbarItem(placement: .topBarLeading) {
                    cancelButton
                }
                ToolbarItem(placement: .topBarTrailing) {
                    addButton
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            if isEditing {
                form
            } else {
                NavigationView {
                    form
                }
            }
        }
        .onChange(of: clusterTask) { oldValue, newValue in
            symbol = clusterTask.symbol
        }
    }
}

#Preview {
    let sampleTask = Task(name: "Go for a swim", symbol: "figure.pool.swim", date: Date(), minuteGroup: .zeroToTen)
    return TaskView(showSymbolPicker: false, isEditing: false, clusterTask: .constant(sampleTask), isShowingTaskView: .constant(false), shouldCreateNewTask: .constant(false))
}
