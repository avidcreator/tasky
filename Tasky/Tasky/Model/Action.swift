//
//  Action.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/22/24.
//

import Foundation

struct Action: Identifiable, Equatable {
    // MARK: - Properties
    var id = UUID().uuidString
    var symbol: String?
    var title: String?
    var destructive: Bool
    
    // MARK: - Initialization
    init(symbol: String, destructive: Bool = false) {
        self.symbol = symbol
        self.destructive = destructive
    }
    
    init(title: String, destructive: Bool = false) {
        self.title = title
        self.destructive = destructive
    }
    
    init(symbol: String, title: String, destructive: Bool = false) {
        self.symbol = symbol
        self.title = title
        self.destructive = destructive
    }
    
    init(id: String, symbol: String?, title: String? = nil, destructive: Bool = false) {
        self.id = id
        self.symbol = symbol
        self.title = title
        self.destructive = destructive
    }
    
    static func make(type: ActionType) -> Action {
        Action(id: type.id, symbol: type.symbol, destructive: type.isDestructive)
    }
    
    // MARK: - Equatable
    static func ==(lhs: Action, rhs: Action) -> Bool {
        return lhs.id == rhs.id
    }
}
