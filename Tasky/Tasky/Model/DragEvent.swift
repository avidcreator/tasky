//
//  DragEvent.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/22/24.
//

import Foundation

struct DragEvent {
    var absoluteOrigin: CGPoint
    var translation: CGSize = .zero
    var absoluteLocation: CGPoint = .zero
    var relativeLocation: CGPoint = .zero
}

