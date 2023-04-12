//
//  NeuExtensions.swift
//  NeuPomodoro
//
//  Created by Lynton Schoeman on 2023-04-10.
//

import SwiftUI

extension Color {
    static let lightStart = Color(red: 245 / 255, green: 245 / 255, blue: 255 / 255)
    static let lightEnd = Color(red: 205 / 255, green: 205 / 255, blue: 215 / 255)
    
    static let darkStart = Color(red: 50 / 255, green: 60 / 255, blue: 65 / 255)
    static let darkEnd = Color(red: 25 / 255, green: 25 / 255, blue: 30 / 255)
}

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}
