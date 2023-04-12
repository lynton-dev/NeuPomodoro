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
    @AppStorage("counterInitial") var sessionLength = 25 * 60
    @AppStorage("breakLength") var breakLength = 5 * 60
    @AppStorage("longBreakLength") var longBreakLength = 15 * 60
    @Published var counter: Int = 25 * 60
    @Published var session = Session()
    var timer = Timer()
    private var running = false
    
    
    func start() {
        if (!running) {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0,
                                              repeats: true) { _ in
                // tick
                self.counter -= 1
                
                if (self.counter <= 0) {
                    // Countdown complete
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
    func pause() {
        self.timer.invalidate()
        running = false
    }
    func reset() {
        pause()
        running = false
        self.counter = sessionLength
    }
    func skip() {
        self.counter = 0
    }
    func nextSession() {
        self.counter = sessionLength
        self.session.mode = .active
        self.session.curSession += 1
        start()
        session.updateSessionUI()
    }
    func startBreak() {
        self.counter = breakLength
        self.session.mode = .breakTime
        start()
        session.updateSessionUI()
    }
    func startLongBreak() {
        self.counter = longBreakLength
        self.session.mode = .longBreak
        self.session.curSession = 0
        start()
        session.updateSessionUI()
    }
    func isRunning() -> Bool {
        return running
    }
}
