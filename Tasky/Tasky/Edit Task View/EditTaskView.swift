//
//  EditTaskView.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/22/24.
//

import SwiftUI

struct EditTaskView: View {
    // MARK: - Properties
    // MARK: Binding Properties
    @Binding var task: Task
    @Binding var isEditing: Bool
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Spacer()
                TextField("Task", text: $task.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    .background {
                        Color.white
                    }
                Spacer()
            }
            .background {
                Color.white.opacity(0.1)
                    .onTapGesture {
                        withAnimation {
                            isEditing = false
                        }
                    }
            }
        }
    }
}

#Preview {
    let task = Task(name: "Go for a walk", symbol: nil, date: Date(), minuteGroup: .zeroToTen)
    return EditTaskView(task: .constant(task), isEditing: .constant(false))
}
