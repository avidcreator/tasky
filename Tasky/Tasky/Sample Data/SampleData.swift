//
//  SampleData.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/22/24.
//

import Foundation

struct SampleData {
    static let clusters: [Cluster] = [
        Cluster(
            hour: Date().hour(),
            minuteGroup: .zeroToTen,
            tasks: [
                Task(name: "Walk the dog", symbol: nil, date: Date(), minuteGroup: .zeroToTen),
                Task(name: "Clean out the closet", symbol: nil, date: Date(), minuteGroup: .zeroToTen),
                Task(name: "Do the laundry", symbol: nil, date: Date(), minuteGroup: .zeroToTen)
            ]
        ),
        Cluster(
            hour: Date().hour(),
            minuteGroup: .tenToTwenty,
            tasks: [
                Task(name: "Go for a walk", symbol: nil, date: Date(), minuteGroup: .zeroToTen),
                Task(name: "Make time for myself", symbol: nil, date: Date(), minuteGroup: .zeroToTen),
                Task(name: "Read a book", symbol: nil, date: Date(), minuteGroup: .zeroToTen),
                Task(name: "Go to the park", symbol: nil, date: Date(), minuteGroup: .zeroToTen),
                Task(name: "Get my oil changed", symbol: nil, date: Date(), minuteGroup: .zeroToTen)
            ]
        )
    ]
}
