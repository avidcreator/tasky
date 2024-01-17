//
//  MinuteGroup.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/17/24.
//

import Foundation

enum MinuteGroup: Int, CaseIterable, Identifiable, Codable {
    var id: String { "\(rawValue)" }
    
    case zeroToTen
    case tenToTwenty
    case twentyToThirty
    case thirtyToForty
    case fortyToFifty
    case fiftyToSixty
    
    static func make(id: String) -> MinuteGroup? {
        switch id {
        case "0": return .zeroToTen
        case "1": return .tenToTwenty
        case "2": return .twentyToThirty
        case "3": return .thirtyToForty
        case "4": return .fortyToFifty
        case "5": return .fiftyToSixty
        default: return nil
        }
    }
    
    static func make(from date: Date) -> MinuteGroup {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let minute = components.minute ?? 0
        
        for group in MinuteGroup.allCases {
            let lowestMinute = group.pair.0
            let highestMinute = group.pair.1
            if minute >= lowestMinute && minute <= highestMinute {
                return group
            }
        }
        return .zeroToTen
    }
    
    var pairStrings: (String, String) {
        switch self {
        case .zeroToTen: return ("00", "10")
        case .tenToTwenty: return ("10", "20")
        case .twentyToThirty: return ("20", "30")
        case .thirtyToForty: return ("30", "40")
        case .fortyToFifty: return ("40", "50")
        case .fiftyToSixty: return ("50", "60")
        }
    }
    
    var pair: (Int, Int) {
        switch self {
        case .zeroToTen: return (0, 10)
        case .tenToTwenty: return (10, 20)
        case .twentyToThirty: return (20, 30)
        case .thirtyToForty: return (30, 40)
        case .fortyToFifty: return (40, 50)
        case .fiftyToSixty: return (50, 60)
        }
    }
    
    var rangeDescription: String {
        switch self {
        case .zeroToTen: return "00 - 10"
        case .tenToTwenty: return "10 - 20"
        case .twentyToThirty: return "20 - 30"
        case .thirtyToForty: return "30 - 40"
        case .fortyToFifty: return "40 - 50"
        case .fiftyToSixty: return "50 - 60"
        }
    }
}
