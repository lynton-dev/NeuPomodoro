//
//  AppIconHelper.swift
//  NeuPomodoro
//
//  Created by Lynton Schoeman on 2023-04-13.
//

import SwiftUI

enum AppIcon: String, CaseIterable, Identifiable {
    case primary = "AppIcon"
    case darkMode = "AppIconDark"

    var id: String { rawValue }
    var iconName: String? {
        switch self {
        case .primary:
            /// `nil` is used to reset the app icon back to its primary icon.
            return nil
        default:
            return rawValue
        }
    }

    var description: String {
        switch self {
        case .primary:
            return "Default"
        case .darkMode:
            return "Dark mode"
        }
    }
}

#if os(iOS)
final class ChangeAppIconViewModel: ObservableObject {
    @Published private(set) var selectedAppIcon: AppIcon
    
    init() {
        if let iconName = UIApplication.shared.alternateIconName, let appIcon = AppIcon(rawValue: iconName) {
            selectedAppIcon = appIcon
        } else {
            selectedAppIcon = .primary
        }
    }
    

    func updateAppIcon(to icon: AppIcon) {
        let previousAppIcon = selectedAppIcon
        selectedAppIcon = icon

        Task { @MainActor in
            guard UIApplication.shared.alternateIconName != icon.iconName else {
                /// No need to update since we're already using this icon.
                return
            }

            do {
                try await UIApplication.shared.setAlternateIconName(icon.iconName)
            } catch {
                /// We're only logging the error here and not actively handling the app icon failure
                /// since it's very unlikely to fail.
                print("Updating icon to \(String(describing: icon.iconName)) failed.")

                /// Restore previous app icon
                selectedAppIcon = previousAppIcon
            }
        }
    }
}
#endif

func updateAppIconPreference() {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("useDarkModeIcon") var useDarkModeIcon = true
    @AppStorage("themeIndex") var themeIndex = Themes.system.index
    
    let themeSetting = Themes.allCases[themeIndex]
    var appIcon = AppIcon.primary
    
    if (useDarkModeIcon) {
        appIcon = AppIcon.darkMode
    }
    
    #if os(macOS)
    NSApplication.shared.applicationIconImage = NSImage(named: (appIcon.iconName ?? AppIcon.primary.iconName) ?? "AppIcon")
    #else
    ChangeAppIconViewModel().updateAppIcon(to: appIcon)
    #endif
}
