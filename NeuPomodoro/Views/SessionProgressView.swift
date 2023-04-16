//
//  SessionProgressView.swift
//  NeuPomodoro
//
//  Created by Lynton Schoeman on 2023-04-12.
//

import SwiftUI

enum ProgressState {
    case none, started, paused
}

struct SessionProgressView: View {
    var value: Int
    @Binding var progressState: ProgressState
    var maximum = 10
    var height = 6.0
    let width = 20.0
    let progressHeight = 10.0
    let progressWidth = 100.0
    var spacing = 3.0
    var unselectedColor: Color = Color.gray.opacity(0.2)
    @ObservedObject var countdownTimer: CountdownTimer

    var body: some View {
        let barValue = (value == 0 ? maximum : value)  // Make the bar full if we are in a long break (i.e. when value = 0)
        
        VStack {
            Spacer()
            
            HStack(alignment: .center, spacing: spacing) {
                ForEach(1 ..< barValue, id: \.self) { index in
                    Rectangle()
                        .foregroundColor(Color.pink.opacity(0.75))
                        .clipShape(Capsule())
                        .frame(width: width, height: height)
                }
                
                ProgressView("", value: CGFloat(self.countdownTimer.curTimerLength - self.countdownTimer.counter), total: CGFloat(self.countdownTimer.curTimerLength))
                    .frame(minWidth: progressState != .none ? progressWidth : width)
                    .frame(height: progressState == .started ? progressHeight : height, alignment: .center)
                    .progressViewStyle(CustomProgressBarStyle(color: self.countdownTimer.session.color, width: progressState != .none ? progressWidth : width, height: progressState == .started ? progressHeight : height))
                
                ForEach(barValue ..< maximum, id: \.self) { index in
                    Rectangle()
                        .foregroundColor(self.unselectedColor)
                        .clipShape(Capsule())
                        .frame(width: width, height: height)
                }
            }
            .animation(.spring(), value: barValue)
            .animation(.spring(), value: progressState)
            
            Spacer()
        }
        .frame(width: (width * CGFloat(maximum - 1)) + (progressState != .none ? progressWidth : width) + (spacing * CGFloat(maximum - 1)), height: height * 2, alignment: .center)    // For frame width, account for each Rectangle plus variable size of the ProgressView plus the spacing between each.
    }
}

struct CustomProgressBarStyle: ProgressViewStyle {
    let color: Color
    let width: CGFloat
    let height: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(color)
                    .frame(width: width, height: height)
                    .opacity(0.2)
                
                Rectangle()
                    .foregroundColor(color)
                    .frame(width: min(CGFloat(configuration.fractionCompleted!) * width, width), height: height)
            }
            .clipShape(Capsule())
            .animation(.easeIn(duration: 0.35), value: color)    // default animation duration in SwiftUI is 0.35 sec.
            .animation(.spring(), value: width)
            .animation(.spring(), value: height)
        }
    }
}
