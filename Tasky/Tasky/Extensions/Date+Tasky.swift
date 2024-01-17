//
//  Date+Tasky.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/17/24.
//

import Foundation

extension Date {
    var timeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
    
    var hour: Int {
        Calendar.current.component(.hour, from: Date())
    }
    
    var hourString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"
        return formatter.string(from: self)
    }
    
    var minuteGroup: MinuteGroup {
        MinuteGroup.make(from: Date())
    }
    
    func isSameDayAs(date: Date) -> Bool {
        let dayA = Calendar.current.component(.day, from: self)
        let dayB = Calendar.current.component(.day, from: date)
        return dayA - dayB == 0
    }
}
