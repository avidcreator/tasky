//
//  MinuteGroupSectionView.swift
//  Tasky
//
//  Created by Fernando Cervantes on 1/17/24.
//

import SwiftUI

struct MinuteGroupSectionView: View {
    var hour: Int
    var minuteGroup: MinuteGroup
    @State var isBolded = false
    
    var body: some View {
        HStack {
            Text("\(hour):\(minuteGroup.pairStrings.0)")
                .foregroundStyle(isBolded ? .black : .gray)
                .font(isBolded ? .title2 : .headline)
                .fontWeight(isBolded ? .bold : .regular)
            Spacer()
        }
        .padding(.horizontal, 20)
        .listRowInsets(.init(top: 0, leading: 0, bottom: -20, trailing: 0))
    }
}

#Preview {
    MinuteGroupSectionView(hour: Date().hour(), minuteGroup: .zeroToTen)
}
