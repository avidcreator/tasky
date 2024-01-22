//
//  ActionType.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/22/24.
//

import Foundation

enum ActionType: String, CaseIterable, Identifiable {
    case edit = "edit"
    case duplicate = "duplicate"
    case delete = "delete"
    
    var id: String { rawValue }
    
    var name: String { rawValue }
    
    var symbol: String {
        switch self {
        case .edit: return "pencil"
        case .duplicate: return "doc.on.doc"
        case .delete: return "trash"
        }
    }
    
    var isDestructive: Bool {
        switch self {
        case .edit, .duplicate:
            return false
        case .delete:
            return true
        }
    }
}
