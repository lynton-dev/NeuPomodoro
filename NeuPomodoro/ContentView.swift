//
//  ContentView.swift
//  NeuPomodoro
//
//  Created by Lynton Schoeman on 2023-04-10.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var countdownTimer = CountdownTimer()
    @State var timerRunning = false
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            VStack {
                // Session indicator
                ZStack {
                    NeuShape(isHighlighted: true, shape: RoundedRectangle(cornerRadius: 25))
                        .frame(width: 130, height: 36)
                    
                    HStack {
                        countdownTimer.session.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(countdownTimer.session.color)
                            .frame(width: 25, height: 25)
                            .padding(.trailing, 10)
                        
                        Text(countdownTimer.session.text)
                            .foregroundColor(countdownTimer.session.color)
                            .fontWeight(.semibold)
                    }
                }
                .padding(EdgeInsets(top: 80, leading: 20, bottom: 0, trailing: 20))
                
                CountdownTimerView(countdownTimer: countdownTimer)
                    .padding(.bottom, 35)
                
                HStack {
                    NeuButton(imageName: self.timerRunning ? "pause.fill" : "play.fill", shape: AnyShape(Circle()), width: 30, height: 30) {
                        // action
                        if (self.timerRunning) {
                            self.countdownTimer.pause()
                            self.timerRunning = false
                        } else {
                            self.countdownTimer.start()
                            self.timerRunning = true
                        }
                    }
                    .help(self.timerRunning ? "Pause" : "Start")
                    .padding()
                    .controlSize(.small)
                    
                    HStack {
                        NeuButton(imageName: "clock.arrow.circlepath", shape: AnyShape(Circle()), width: 12, height: 12) {
                            // action
                            self.countdownTimer.reset()
                        }
                        .help("Reset")
                        .padding(.trailing, 15)
                        
                        NeuButton(imageName: "forward.end", shape: AnyShape(Circle()), width: 12, height: 12) {
                            // action
                            self.countdownTimer.skip()
                        }
                        .help("Skip")
                    }
                    .padding()
                }
                .padding(.bottom, 50)
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
