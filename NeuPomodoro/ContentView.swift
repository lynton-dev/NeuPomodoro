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
    @AppStorage("themeIndex") var themeIndex = Themes.system.index
    @State var timerState = ProgressState.none
    @State private var isShowingSettingsView = false
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                Color("Background")
                .ignoresSafeArea()
            
                VStack {
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
                        Spacer()
                        
                        HStack {
                            NeuButton(imageName: "clock.arrow.circlepath", shape: AnyShape(Circle()), width: 15, height: 15, imageWidth: 15, imageHeight: 15) {
                                // action
                                if (self.countdownTimer.session.mode != .none) {
                                    self.countdownTimer.reset()
                                    self.timerState = .paused
                                }
                            }
                            .help("Reset")
                            
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
                            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                            
                            NeuButton(imageName: "forward.end", shape: AnyShape(Circle()), width: 15, height: 15, imageWidth: 12, imageHeight: 12) {
                                // action
                                self.countdownTimer.skip()
                                self.timerState = .started
                            }
                            .help("Skip")
                        }
                        .padding(EdgeInsets(top: 30, leading: 0, bottom: 40, trailing: 0))
                        
                        Spacer()
                        
                        // Session progress
                        ZStack {
                            NeuShape(isHighlighted: true, shape: Rectangle())
                                .padding(.bottom, -40)
                            
                            SessionProgressView(value: countdownTimer.session.curSession, progressState: $timerState, maximum: numSessions, countdownTimer: countdownTimer)
                                .padding(.bottom, 5)
                        }
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .padding(EdgeInsets(top: 0, leading: -30, bottom: -20, trailing: -30))
                    }
                }
                .padding()
                .frame(maxHeight: .infinity, alignment: .bottom)    // align to the bottom
                .opacity(self.isShowingSettingsView ? 0 : 1)
                .animation(.easeInOut, value: self.isShowingSettingsView)
                .toolbar {
                    ToolbarItemGroup(placement: .primaryAction) {
                        NavigationLink(destination:
                            SettingsView(countdownTimer: countdownTimer)
                            .opacity(self.isShowingSettingsView ? 1 : 0)
                            .animation(.easeInOut, value: self.isShowingSettingsView)
                            .onAppear() {
                                self.isShowingSettingsView = true
                            }
                            .onDisappear() {
                                self.isShowingSettingsView = false
                            }
                                       
                        ) {
                            Image(systemName: "switch.2")
                        }
                        .disabled(self.isShowingSettingsView)
                    }
                }
                .onAppear() {
                    // Request notification permission
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                        if granted {
                            
                        } else if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                    
                    // If macOS, immediately update icon based on system dark mode
                    #if os(macOS)
                    updateAppIconPreference()
                    #endif
                }
            }
        }
        .navigationTitle("")
        .toolbarBackground(.clear)
        .background(Color("Background"))
        .preferredColorScheme(themeIndex == 1 ? .light : themeIndex == 2 ? .dark : nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
