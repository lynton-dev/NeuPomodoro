//
//  SettingsView.swift
//  NeuPomodoro
//
//  Created by Lynton Schoeman on 2023-04-16.
//

import SwiftUI

enum Themes: CustomStringConvertible, CaseIterable {
    case system, light, dark
    
    var description: String {
        switch self {
            case .system: return "System default"
            case .light: return "Light"
            case .dark: return "Dark"
        }
    }
    
    var index: Int {
        switch self {
            case .system: return 0
            case .light: return 1
            case .dark: return 2
        }
    }
}

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var countdownTimer: CountdownTimer
    
    @AppStorage("useDarkModeIcon") var useDarkModeIcon = true
    @AppStorage("themeIndex") var themeIndex = Themes.system.index
    @AppStorage("numSessions") var numSessions = SessionDefaults.DEFAULT_NUM_SESSIONS
    @AppStorage("sessionLength") var sessionLength = SessionDefaults.DEFAULT_SESSION_LENGTH_SECS
    @AppStorage("breakLength") var breakLength = SessionDefaults.DEFAULT_BREAK_SECS
    @AppStorage("longBreakLength") var longBreakLength = SessionDefaults.DEFAULT_LONG_BREAK_SECS
    
    @State var sessionsIndex = 0
    let themes = [Themes.system.description, Themes.light.description, Themes.dark.description]
    
    var body: some View {
        #if os(macOS)
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            MacSettings {
                MacSettingsItem(title: "Sessions",
                                image: "clock",
                                content: sessionsSettings)
                MacSettingsItem(title: "Appearance",
                                image: "paintbrush",
                                content: appearanceSettings)
                MacSettingsItem(title: "About",
                                image: "questionmark.circle",
                                content: aboutSettings)
            }
        }
        .navigationTitle("Settings")
        
        #else
        
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            SettingsTabView(
                tabBarPosition: .top,
                content: [
                    (
                        tabText: "Sessions",
                        tabIconName: "clock",
                        view: AnyView(
                            sessionsSettings
                        )
                    ),
                    (
                        tabText: "Appearance",
                        tabIconName: "paintbrush",
                        view: AnyView(
                            appearanceSettings
                        )
                    ),
                    (
                        tabText: "About",
                        tabIconName: "questionmark.circle",
                        view: AnyView(
                            aboutSettings
                        )
                    )
                ]
            )
        }
        .toolbarBackground(Color("Background"))
        .navigationTitle("Settings")
        
        #endif
    }
    
    var sessionsSettings: some View {
        VStack {
            Form {
                Section {
                    LabeledContent {
                        Picker(selection: $sessionsIndex, label: Text("")) {
                            ForEach(0..<SessionDefaults.MAX_NUM_SESSIONS, id:\.self) { index in
                                Text((index+1).description)
                            }
                        }
                        .onChange(of: sessionsIndex) { value in
                            self.countdownTimer.session.numSessions = self.sessionsIndex + 1
                        }
                        .onAppear() {
                            self.sessionsIndex = self.numSessions - 1
                        }
                        .frame(maxWidth: 80)
                        
                        Text(self.numSessions == 1 ? "  session" : "  sessions")
                    } label: {
                        Text("Long break after:")
                    }
                    
                    LabeledContent {
                        TextField("", value: $sessionLength, formatter: SessionFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of:sessionLength) { value in
                                countdownTimer.resetSessionLength()
                            }
                            .frame(maxWidth: 80)
                        
                        Text(self.sessionLength == 60 ? "  minute" : "  minutes")
                    } label: {
                        Text("Session length:")
                    }
                    
                    LabeledContent {
                        TextField("", value: $breakLength, formatter: SessionFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of:breakLength) { value in
                                countdownTimer.resetBreakLength()
                            }
                            .frame(maxWidth: 80)
                        
                        Text(self.breakLength == 60 ? "  minute" : "  minutes")
                    } label: {
                        Text("Break length:")
                    }
                    
                    LabeledContent {
                        TextField("", value: $longBreakLength, formatter: SessionFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of:longBreakLength) { value in
                                countdownTimer.resetLongBreakLength()
                            }
                            .frame(maxWidth: 80)
                        
                        Text(self.longBreakLength == 60 ? "  minute" : "  minutes")
                    } label: {
                        Text("Long break length:")
                    }
                    
                    Button("Reset", action: {
                        numSessions = SessionDefaults.DEFAULT_NUM_SESSIONS
                        sessionsIndex = numSessions - 1
                        sessionLength = SessionDefaults.DEFAULT_SESSION_LENGTH_SECS
                        breakLength = SessionDefaults.DEFAULT_BREAK_SECS
                        longBreakLength = SessionDefaults.DEFAULT_LONG_BREAK_SECS
                    })
                    .padding(EdgeInsets(top: 3, leading: 5, bottom: 0, trailing: 0))
                }
                
                #if os(macOS)
                Spacer()
                #endif
            }
            .scrollContentBackground(.hidden)
            .padding(.top, 15)
        }
    }
    
    var appearanceSettings: some View {
        Form {
            Section {
                LabeledContent {
                    Picker(selection: $themeIndex, label: Text("")) {
                        ForEach(themes.indices, id:\.self) { index in
                            Text(self.themes[index])
                        }
                    }
                    .onChange(of: themeIndex) { value in
                        updateAppIconPreference()
                    }
                    .frame(maxWidth: 175)
                } label: {
                    Text("Theme:")
                }
                
                if ((themeIndex == Themes.dark.index) || (themeIndex == Themes.system.index && colorScheme == .dark)) {
                    LabeledContent {
                        Toggle("", isOn: $useDarkModeIcon)
                            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                            .animation(.easeInOut, value: self.themeIndex)
                            .onChange(of: useDarkModeIcon) { value in
                                updateAppIconPreference()
                            }
                    } label: {
                        Text("Use dark icon:")
                    }
                }
            }

            #if os(macOS)
            Spacer()
            #endif
        }
        .scrollContentBackground(.hidden)
        .padding()
    }
    
    var aboutSettings: some View {
        Form {
            Section {
                LabeledContent {

                } label: {
                    Text("About")
                }
            }

            #if os(macOS)
            Spacer()
            #endif
        }
        .scrollContentBackground(.hidden)
        .padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(countdownTimer: CountdownTimer())
    }
}

class SessionFormatter: NumberFormatter {
    private var sessionLength: Int = 0
    
    override func string(for obj: Any?) -> String? {
        if let secs = obj as? Int {
            let sessionLength = max(1, secs / 60)  // min value is 1 minute
            return super.string(for: sessionLength)
        }
        return super.string(for: obj)
    }
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        if let sessionLength = Int(string) {
            self.sessionLength = sessionLength
            obj?.pointee = NSNumber(value: sessionLength * 60)
            return true
        }
        return false
    }
}
