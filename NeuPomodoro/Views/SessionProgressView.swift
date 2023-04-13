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
    let width = 15.0
    var progressWidth = 60.0
    var spacing: CGFloat = 2.5
    var unselectedColor: Color = Color.gray.opacity(0.2)
    @ObservedObject var countdownTimer: CountdownTimer

    var body: some View {
        let barValue = (value == 0 ? maximum : value)  // Make the bar full if we are in a long break (i.e. when value = 0)
        
        HStack(alignment: .center, spacing: spacing) {
            ForEach(1 ..< barValue, id: \.self) { index in
                Rectangle()
                    .foregroundColor(Color(NSColor.textColor).opacity(0.8))
                    .clipShape(Capsule())
                    .frame(width: width)
            }
            
            ProgressView("", value: CGFloat(self.countdownTimer.curTimerLength - self.countdownTimer.counter), total: CGFloat(self.countdownTimer.curTimerLength))
                .tint(self.countdownTimer.session.color)
                .frame(minWidth: progressWidth)
                .padding(.top, -14)
            
            ForEach(barValue ..< maximum, id: \.self) { index in
                Rectangle()
                    .foregroundColor(self.unselectedColor)
                    .clipShape(Capsule())
                    .frame(width: width)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: barValue)
        .frame(maxWidth: (width * CGFloat(maximum)) + progressWidth, maxHeight: height)
    }
}
