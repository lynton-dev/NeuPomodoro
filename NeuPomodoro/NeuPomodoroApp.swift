//
//  NeuPomodoroApp.swift
//  NeuPomodoro
//
//  Created by Lynton Schoeman on 2023-04-10.
//

import SwiftUI

#if os(macOS)
@main
struct NeuPomodoroApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 500, minHeight: 400)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}
#else
@main
struct NeuPomodoroApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
#endif
