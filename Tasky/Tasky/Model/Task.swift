//
//  Task.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/17/24.
//

import Foundation
//import SwiftData

//@Model
final class Task: Identifiable, Equatable {
    // MARK: - Properties
    var id = UUID().uuidString
    var name: String
    var symbol: String?
    var date: Date
    var minuteGroup: MinuteGroup
    
    // MARK: - Initialization
    init(id: String = UUID().uuidString, name: String, symbol: String?, date: Date, minuteGroup: MinuteGroup) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.date = date
        self.minuteGroup = minuteGroup
    }
    
    static func duplicate(_ task: Task) -> Task {
        return Task(name: task.name, symbol: task.symbol, date: Date(), minuteGroup: task.minuteGroup)
    }
    
    // MARK: - Equatable
    static func ==(lhs: Task, rhs: Task) -> Bool {
        return lhs.id == rhs.id
    }
}
