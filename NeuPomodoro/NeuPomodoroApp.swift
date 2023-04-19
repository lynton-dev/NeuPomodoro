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
                //.presentedWindowToolbarStyle(.unified(showsTitle: true))
                .frame(minWidth: 500, minHeight: 400)
        }
        //.windowToolbarStyle(.unifiedCompact(showsTitle: true))
        //.windowStyle(HiddenTitleBarWindowStyle())
    }
}

#else

@main
struct NeuPomodoroApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                //.toolbarBackground(.hidden, for: .navigationBar)
        }
    }
}

extension UINavigationBar {
    static func changeAppearance(clear: Bool) {
        let appearance = UINavigationBarAppearance()

        if clear {
            appearance.configureWithTransparentBackground()
        } else {
            appearance.configureWithDefaultBackground()
        }

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
#endif
