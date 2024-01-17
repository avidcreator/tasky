//
//  Task.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/17/24.
//

import Foundation

final class Task: Identifiable {
    var id = UUID().uuidString
    var name: String
    var symbol: String?
    var date: Date
    var minuteGroup: MinuteGroup
    
    init(id: String = UUID().uuidString, name: String, symbol: String?, date: Date, minuteGroup: MinuteGroup) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.date = date
        self.minuteGroup = minuteGroup
    }
}
