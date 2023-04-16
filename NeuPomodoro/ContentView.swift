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
    @State var timerState = ProgressState.none

    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            VStack {
//                #if os(iOS)
//                Button(action: {
//                    ChangeAppIconViewModel().updateAppIcon(to: .darkMode)
//                }){
//                    Image(uiImage: UIImage(named: "AppIconiOSDark") ?? UIImage())
//                        .cornerRadius(20)
//                }
//                #else
//                Button(action: {
//                    NSApplication.shared.applicationIconImage = NSImage(named: "AppIconDark")
//                }){
//                    Image(nsImage: NSImage(named: "AppIconDark") ?? NSImage())
//                        .cornerRadius(20)
//                }
//                #endif
                
                Spacer()
                
                // Session indicator
                ZStack {
                    VStack {
                        HStack {
                            countdownTimer.session.image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(countdownTimer.session.color)
                                .frame(width: 25, height: 25)
                                .padding(.leading, 5)
                                .frame(width: 25)
                                .animation(.easeIn(duration: 0.35), value: countdownTimer.session.color)
                            
                            Spacer()
                            
                            Text(countdownTimer.session.text)
                                .foregroundColor(countdownTimer.session.color)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 90)
                                .animation(.easeIn(duration: 0.35), value: countdownTimer.session.color)
                        }
                        .frame(width: 100)
                    }
                }
                .background(
                    NeuShape(isHighlighted: true, shape: RoundedRectangle(cornerRadius: 25))
                        .frame(width: 150, height: 36)
                )
                .padding(EdgeInsets(top: 30, leading: 20, bottom: 10, trailing: 20))
                
                CountdownTimerView(countdownTimer: countdownTimer)
                
                Spacer()
                
                VStack {
                    HStack {
                        NeuButton(imageName: self.countdownTimer.running ? "pause.fill" : "play.fill", shape: AnyShape(Circle()), width: 30, height: 30, imageWidth: 20, imageHeight: 20) {
                            // action
                            if (self.countdownTimer.running) {
                                self.countdownTimer.pauseClicked()
                                self.timerState = .paused
                            } else {
                                self.countdownTimer.start()
                                self.timerState = .started
                            }
                        }
                        .help(self.countdownTimer.running ? "Pause" : "Start")
                        .padding(.trailing, 10)
                        
                        HStack {
                            NeuButton(imageName: "clock.arrow.circlepath", shape: AnyShape(Circle()), width: 15, height: 15, imageWidth: 15, imageHeight: 15) {
                                // action
                                self.countdownTimer.reset()
                                self.timerState = .paused
                            }
                            .help("Reset")
                            .padding(.trailing, 15)
                            
                            NeuButton(imageName: "forward.end", shape: AnyShape(Circle()), width: 15, height: 15, imageWidth: 12, imageHeight: 12) {
                                // action
                                self.countdownTimer.skip()
                                self.timerState = .started
                            }
                            .help("Skip")
                        }
                        .padding()
                    }
                    .padding(EdgeInsets(top: 30, leading: 0, bottom: 40, trailing: 0))
                    
                    SessionProgressView(value: countdownTimer.session.curSession, progressState: $timerState, maximum: numSessions, countdownTimer: countdownTimer)
                    .padding(.bottom, 5)
                }
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .bottom)    // align to the bottom
        }
        .onAppear() {
            // Request notification permission
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if granted {
                    
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
            
            // Update icon based on system dark mode
            #if os(macOS)
            //NSApplication.shared.applicationIconImage = NSImage(named: "AppIconDark")
            #else
            ChangeAppIconViewModel().updateAppIcon(to: .darkMode)
            #endif
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
