//
//  Cluster.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/22/24.
//

import Foundation
import SwiftData

@Model
final class Cluster: Identifiable, Equatable {
    // MARK: - Properties
    var id = UUID().uuidString
    var hour: Int
    var minuteGroup: MinuteGroup
    private(set) var tasks: [Task]
    
    
    // MARK: - Equatable
    static func ==(lhs: Cluster, rhs: Cluster) -> Bool {
        return lhs.id == rhs.id
    }
    
    // MARK: - Initialization
    init(id: String = UUID().uuidString, hour: Int, minuteGroup: MinuteGroup, tasks: [Task]) {
        self.id = id
        self.hour = hour
        self.minuteGroup = minuteGroup
        self.tasks = tasks
    }
    
    // MARK: - Retrieval
    var title: String { "\(hour):\(minuteGroup.pairStrings.0)" }
    
    func index(ofTask task: Task) -> Int? {
        for itemIndex in 0..<tasks.count {
            let enumeratedTask = tasks[itemIndex]
            if enumeratedTask == task {
                return itemIndex
            }
        }
        return nil
    }
    
    // MARK: - Tasks
    func insert(_ task: Task, at index: Int) {
        guard index <= tasks.count else { return }
        tasks.insert(task, at: index)
    }
    
    func add(_ task: Task) {
        tasks.append(task)
    }
    
    func remove(_ task: Task) {
        tasks.removeAll(where: { $0 == task })
    }
    
    func replace(task originalTask: Task, withTask newTask: Task) {
        guard let index = tasks.firstIndex(where: { $0 == originalTask }) else { return }
        tasks[index] = newTask
    }
    
    func move(task: Task, to finalIndex: Int) {
        guard finalIndex <= tasks.count else { return }
        guard let originIndex = tasks.firstIndex(where: { $0 == task }) else { return }
        let originIndexSet = IndexSet(integer: originIndex)
        tasks.move(fromOffsets: originIndexSet, toOffset: finalIndex)
    }
}

