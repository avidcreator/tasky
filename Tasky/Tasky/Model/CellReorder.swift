//
//  CellReorder.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/22/24.
//

import Foundation

struct CellReorder: Equatable {
    var originClusterId: String
    var finalClusterId: String
    var originIndex: Int
    var finalIndex: Int
    
    static func ==(lhs: CellReorder, rhs: CellReorder) -> Bool {
        return lhs.originClusterId == rhs.originClusterId
    }
}
