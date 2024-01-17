//
//  MinuteGroupView.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/17/24.
//

import SwiftUI

struct MinuteGroupView: View {
    var hour: Int
    var minuteGroup: MinuteGroup
    var tasks: [Task]
    @Binding var minuteGroupSelected: String?
    @State var isHighlighted: Bool
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("\(hour):\(minuteGroup.pairStrings.0) - \(hour):\(minuteGroup.pairStrings.1)")
                        .foregroundStyle(.black)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.top, 12)
                        .padding(.horizontal, 12)
                    Spacer()
                }
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(tasks) { task in
                        HStack {
                            Block(name: task.name, symbol: task.symbol, isHighlighted: $isHighlighted)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 2)
                    }
                }
            }
            .padding(.vertical)
        }
        .background {
            Rectangle()
                .fill(Color(minuteGroupSelected == minuteGroup.id ? .systemGray6 : .clear))
        }
    }
}

#Preview {
    let sampleTasks: [Task] = [
        Task(name: "Do laundry", symbol: nil, date: Date(), minuteGroup: .tenToTwenty),
        Task(name: "Drink water", symbol: nil, date: Date(), minuteGroup: .tenToTwenty)
    ]
    return MinuteGroupView(
        hour: Date().hour,
        minuteGroup: .tenToTwenty,
        tasks: sampleTasks,
        minuteGroupSelected: .constant(nil),
        isHighlighted: false
    )
}
