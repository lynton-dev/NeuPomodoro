//
//  Session.swift
//  NeuPomodoro
//
//  Created by Lynton Schoeman on 2023-04-11.
//

import SwiftUI

enum SessionMode {
    case active, breakTime, longBreak
}

class Session {
    @Published var mode = SessionMode.active
    @Published var text = "Active"
    @Published var image = Image(systemName: "bolt.circle.fill")
    @Published var color = Color.pink
    var curSession = 1
    @AppStorage("numSessions") var numSessions = 4
    @AppStorage("breakLength") var breakLength = 5 * 60
    @AppStorage("longBreakLength") var longBreakLength = 15 * 60
    
    func updateSessionUI() {
        updateSessionText()
        updateSessionColor()
        updateSessionImage()
    }
    
    private func updateSessionText() {
        switch self.mode {
        case .active:
            self.text = "Active"
        case .breakTime:
            self.text = "Break"
        case .longBreak:
            self.text = "Long Break"
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
        }
    }
}
