//
//  CountdownTimer.swift
//  NeuPomodoro
//
//  Created by Lynton Schoeman on 2023-04-10.
//

import SwiftUI
import UserNotifications

struct CountdownTimerView: View {
    @ObservedObject var countdownTimer: CountdownTimer
    
    var body: some View {
        let minutes = String(format: "%02d", countdownTimer.counter / 60)
        let seconds = String(format: "%02d", countdownTimer.counter % 60)
        let union = minutes + " : " + seconds
        
        Text("\(union)")
            .font(.system(size: 70, weight: .light, design: .default)).monospacedDigit()
    }
}

class CountdownTimer: ObservableObject {
    @AppStorage("sessionLength") var sessionLength = SessionDefaults.DEFAULT_SESSION_LENGTH_SECS
    @AppStorage("breakLength") var breakLength = SessionDefaults.DEFAULT_BREAK_SECS
    @AppStorage("longBreakLength") var longBreakLength = SessionDefaults.DEFAULT_LONG_BREAK_SECS
    @Published var counter: Int = SessionDefaults.DEFAULT_SESSION_LENGTH_SECS
    @Published var session = Session()
    @Published var running = false
    @Published var curTimerLength = SessionDefaults.DEFAULT_SESSION_LENGTH_SECS
    private var timer = Timer()
    private var prePausedMode = SessionMode.active
    private var skipIt = false
    
    init() {
        counter = sessionLength
    }    
    
    func start() {
        if (!running) {
            if (self.session.mode == .none) {
                self.session.mode = .active
                self.session.updateSessionUI()
            } else if (self.session.mode == .paused) {
                self.session.mode = self.prePausedMode
                self.session.updateSessionUI()
            }
            
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0,
                                              repeats: true) { _ in
                // tick
                self.counter -= 1
                
                if (self.counter <= 0 || self.skipIt) {
                    // Countdown complete
                    self.skipIt = false
                    self.pause()
                    
                    if (self.session.curSession == self.session.numSessions) {    // Reached our number of sessions limit -> long break
                        self.startLongBreak()
                    } else {
                        if (self.session.mode == .active) {
                            self.startBreak()
                        } else {
                            self.nextSession()
                        }
                    }
                }
            }
            running = true
        }
    }
    func notify() {
        let content = UNMutableNotificationContent()
        var doNotify = true
        
        switch self.session.mode {
        case .active:
            content.title = "Start next session"
            content.subtitle = "Break is over!"
        case .breakTime:
            content.title = "Break started"
            content.subtitle = "Take a breather"
        case .longBreak:
            content.title = "Long break started"
            content.subtitle = "You've earned it!"
        case .paused:
            doNotify = false
        case .none:
            doNotify = false
        }
        
        if (doNotify) {
            content.sound = UNNotificationSound.default
            
            // show this notification 1 seconds from now
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            
            // choose a random identifier
            //let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            // I am instead using a hardcoded identifier so that each new notification replaces the last (no stacking notifications)
            let request = UNNotificationRequest(identifier: "NeuPomodoro", content: content, trigger: trigger)
            
            // add our notification request
            UNUserNotificationCenter.current().add(request) { (error) in
                if error != nil {
                    print("Error adding notification")
                }
            }
        }
    }
    // To implement stop button? (Would start over completely)
    func stop() {
        reset()
        self.session.curSession = 1
        self.session.mode = .none
    }
    func pause() {
        self.timer.invalidate()
        running = false
    }
    func pauseClicked() {
        pause()
        self.prePausedMode = self.session.mode
        self.session.mode = .paused
        self.session.updateSessionUI()
    }
    func reset() {
        pause()
        running = false
        var sessionMode = self.session.mode
        if (self.session.mode == .paused) {
            sessionMode = self.prePausedMode
        }
        switch sessionMode {
        case .active:
            resetSessionLength()
        case .breakTime:
            resetBreakLength()
        case .longBreak:
            resetLongBreakLength()
        case .paused:
            resetSessionLength()
        case .none:
            resetSessionLength()
        }
    }
    func resetSessionLength() {
        if (session.mode == .active || session.mode == .none) {
            self.counter = sessionLength
            self.curTimerLength = sessionLength
        }
    }
    func resetBreakLength() {
        if (session.mode == .breakTime) {
            self.counter = breakLength
            self.curTimerLength = breakLength
        }
    }
    func resetLongBreakLength() {
        if (session.mode == .longBreak) {
            self.counter = longBreakLength
            self.curTimerLength = longBreakLength
        }
    }
    func skip() {
        pause()
        self.skipIt = true
        if (self.session.mode == .paused) {
            self.session.mode = self.prePausedMode
        }
        start()
    }
    func nextSession() {
        self.counter = sessionLength
        self.curTimerLength = sessionLength
        self.session.mode = .active
        self.session.curSession += 1
        start()
        self.session.updateSessionUI()
        notify()
    }
    func startBreak() {
        self.counter = breakLength
        self.curTimerLength = breakLength
        self.session.mode = .breakTime
        start()
        self.session.updateSessionUI()
        notify()
    }
    func startLongBreak() {
        self.counter = longBreakLength
        self.curTimerLength = longBreakLength
        self.session.mode = .longBreak
        self.session.curSession = 0
        start()
        self.session.updateSessionUI()
        notify()
    }
    func isRunning() -> Bool {
        return running
    }
}
