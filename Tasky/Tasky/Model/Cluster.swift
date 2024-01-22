//
//  Cluster.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/22/24.
//

import Foundation

struct Cluster: Identifiable, Equatable {
    // MARK: - Properties
    var id = UUID().uuidString
    var title: String
    private(set) var tasks: [Task]
    
    // MARK: - Retrieval
    func index(ofTask task: Task) -> Int? {
        for itemIndex in 0..<tasks.count {
            let enumeratedTask = tasks[itemIndex]
            if enumeratedTask == task {
                return itemIndex
            }
        }
        return nil
    }
    
    // MARK: - Equatable
    static func ==(lhs: Cluster, rhs: Cluster) -> Bool {
        return lhs.tasks == rhs.tasks
    }
    
    // MARK: - Tasks
    mutating func insert(_ task: Task, at index: Int) {
        guard index <= tasks.count else { return }
        tasks.insert(task, at: index)
    }
    
    mutating func add(_ task: Task) {
        tasks.append(task)
    }
    
    mutating func remove(_ task: Task) {
        tasks.removeAll(where: { $0 == task })
    }
    
    mutating func replace(task originalTask: Task, withTask newTask: Task) {
        guard let index = tasks.firstIndex(where: { $0 == originalTask }) else { return }
        tasks[index] = newTask
    }
    
    mutating func move(task: Task, to finalIndex: Int) {
        guard finalIndex <= tasks.count else { return }
        guard let originIndex = tasks.firstIndex(where: { $0 == task }) else { return }
        let originIndexSet = IndexSet(integer: originIndex)
        tasks.move(fromOffsets: originIndexSet, toOffset: finalIndex)
    }
}
