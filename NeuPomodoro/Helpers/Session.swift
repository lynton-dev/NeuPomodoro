//
//  Session.swift
//  NeuPomodoro
//
//  Created by Lynton Schoeman on 2023-04-11.
//

import SwiftUI

enum SessionMode {
    case active, breakTime, longBreak, paused, none
}

struct SessionDefaults {
    static let DEFAULT_NUM_SESSIONS = 4
    static let DEFAULT_BREAK_SECS = 5 * 60          // 5 mins
    static let DEFAULT_LONG_BREAK_SECS = 15 * 60    // 15 mins
    static let DEFAULT_SESSION_LENGTH_SECS = 25 * 60       // 25 mins
}

class Session {
    @Published var mode = SessionMode.none
    @Published var text = "Ready"
    @Published var image = Image(systemName: "circle.dashed")
    @Published var color = Color.gray
    @AppStorage("numSessions") var numSessions = SessionDefaults.DEFAULT_NUM_SESSIONS
    @AppStorage("breakLength") var breakLength = SessionDefaults.DEFAULT_BREAK_SECS
    @AppStorage("longBreakLength") var longBreakLength = SessionDefaults.DEFAULT_LONG_BREAK_SECS
    var curSession = 1
    
    func updateSessionUI() {
        updateSessionText()
        updateSessionImage()
        updateSessionColor()
    }
    
    private func updateSessionText() {
        switch self.mode {
        case .active:
            self.text = "Active"
        case .breakTime:
            self.text = "Break"
        case .longBreak:
            self.text = "Long Break"
        case .paused:
            self.text = "Paused"
        case .none:
            self.text = "Ready"
        }
    }
    
    private func updateSessionImage() {
        switch self.mode {
        case .active:
            self.image = Image(systemName: "bolt.circle.fill")
        case .breakTime:
            self.image = Image(systemName: "wind.circle.fill")
        case .longBreak:
            self.image = Image(systemName: "moon.circle.fill")
        case .paused:
            self.image = Image(systemName: "pause.circle.fill")
        case .none:
            self.image = Image(systemName: "circle.dashed")
        }
    }
    
    private func updateSessionColor() {
        switch self.mode {
        case .active:
            self.color = Color.pink
        case .breakTime:
            self.color = Color.blue
        case .longBreak:
            self.color = Color.indigo
        case .paused:
            self.color = Color.yellow.opacity(0.8)
        case .none:
            self.color = Color.gray
        }
    }
}
