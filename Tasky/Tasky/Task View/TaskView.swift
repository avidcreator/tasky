//
//  TaskView.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/17/24.
//

import SwiftUI
import SymbolPicker
//import SwiftData

struct TaskView: View {
//    @Environment (\.modelContext) private var context
    @State var task: Task
    @State var showSymbolPicker: Bool
    @Binding var isShowingTaskView: Bool
    @Binding var minuteGroupSelected: String?
    @State var isEditing: Bool
    
    private var cancelButton: some View {
        Button("Cancel") {
            isShowingTaskView = false
        }
    }
    
    private var addButton: some View {
        Button {
//            context.insert(task)
            isShowingTaskView = false
            minuteGroupSelected = nil
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
                        SymbolView(systemName: task.symbol ?? "", size: .medium, style: .highlighted)
                    }
                    .sheet(isPresented: $showSymbolPicker) {
                        SymbolPicker(symbol: $task.symbol)
                    }
                    Spacer()
                }
                NameView(placeholder: "name your task", name: $task.name)
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
        .onDisappear {
            minuteGroupSelected = nil
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
    }
}

#Preview {
    let sampleTask = Task(name: "Go for a swim", symbol: "figure.pool.swim", date: Date(), minuteGroup: .zeroToTen)
    return TaskView(task: sampleTask, showSymbolPicker: false, isShowingTaskView: .constant(false), minuteGroupSelected: .constant(nil), isEditing: false)
}
