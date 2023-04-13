//
//  ContentView.swift
//  NeuPomodoro
//
//  Created by Lynton Schoeman on 2023-04-10.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var countdownTimer = CountdownTimer()
    @AppStorage("numSessions") var numSessions = SessionDefaults.DEFAULT_NUM_SESSIONS
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            VStack {
                // Session indicator
                ZStack {
                    NeuShape(isHighlighted: true, shape: RoundedRectangle(cornerRadius: 25))
                        .frame(width: 150, height: 36)
                    
                    HStack {
                        countdownTimer.session.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(countdownTimer.session.color)
                        .frame(width: 25, height: 25)
                        .padding(.leading, 5)
                        .frame(width: 25)
                        
                        Spacer()
                        
                        Text(countdownTimer.session.text)
                        .foregroundColor(countdownTimer.session.color)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 90)
                    }
                    .frame(width: 100)
                }
                .padding(EdgeInsets(top: 50, leading: 20, bottom: 0, trailing: 20))
                
                CountdownTimerView(countdownTimer: countdownTimer)
                
                SessionProgressView(value: countdownTimer.session.curSession, maximum: numSessions, countdownTimer: countdownTimer)
                    .animation(.default, value: countdownTimer.session.curSession)
                    .frame(width: 150, height: 5)
                    .padding(EdgeInsets(top: -30, leading: 0, bottom: 40, trailing: 0))
                
                HStack {
                    NeuButton(imageName: self.countdownTimer.running ? "pause.fill" : "play.fill", shape: AnyShape(Circle()), width: 30, height: 30) {
                        // action
                        if (self.countdownTimer.running) {
                            self.countdownTimer.pauseClicked()
                        } else {
                            self.countdownTimer.start()
                        }
                    }
                    .help(self.countdownTimer.running ? "Pause" : "Start")
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
                        .opacity(self.countdownTimer.session.mode == .none ? 0 : 1)
                        .animation(.spring(), value: self.countdownTimer.session.mode)
                        .help("Skip")
                    }
                    .padding()
                }
                .padding(.bottom, 50)
            }
            .padding()
        }
        .onAppear() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if granted {
                    
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
