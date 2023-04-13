//
//  SessionProgressView.swift
//  NeuPomodoro
//
//  Created by Lynton Schoeman on 2023-04-12.
//

import SwiftUI

struct SessionProgressView: View {
    var value: Int
    var maximum: Int = 10
    var height: CGFloat = 5
    var spacing: CGFloat = 2
    var unselectedColor: Color = Color.secondary.opacity(0.3)
    @ObservedObject var countdownTimer: CountdownTimer

    var body: some View {
        let barValue = (value == 0 ? maximum : value)  // Make the bar full if we are in a long break (i.e. when value = 0)
        
        HStack(spacing: spacing) {
            ForEach(0 ..< maximum, id: \.self) { index in
                Rectangle()
                    .foregroundColor(index < barValue ? self.countdownTimer.session.color : self.unselectedColor)
            }
        }
        .frame(maxWidth: CGFloat(15 * maximum), maxHeight: height)
        .clipShape(Capsule())
    }
}
