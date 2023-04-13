//
//  CountdownTimer.swift
//  NeuPomodoro
//
//  Created by Lynton Schoeman on 2023-04-10.
//

import SwiftUI

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
    private var timer = Timer()
    private var prePausedMode = SessionMode.active
    private var skipIt = false
    
    
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
            self.counter = sessionLength
        case .breakTime:
            self.counter = breakLength
        case .longBreak:
            self.counter = longBreakLength
        case .paused:
            self.counter = sessionLength
        case .none:
            self.counter = sessionLength
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
        self.session.mode = .active
        self.session.curSession += 1
        start()
        self.session.updateSessionUI()
    }
    func startBreak() {
        self.counter = breakLength
        self.session.mode = .breakTime
        start()
        self.session.updateSessionUI()
    }
    func startLongBreak() {
        self.counter = longBreakLength
        self.session.mode = .longBreak
        self.session.curSession = 0
        start()
        self.session.updateSessionUI()
    }
    func isRunning() -> Bool {
        return running
    }
}
