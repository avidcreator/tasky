//
//  TaskyApp.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/17/24.
//

import SwiftUI
import SwiftData

@main
struct TaskyApp: App {
    var body: some Scene {
        WindowGroup {
            NowView()
        }
        .modelContainer(for: Task.self)
    }
}
