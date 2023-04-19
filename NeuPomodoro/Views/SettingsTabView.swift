//
//  SettingsTabView.swift
//  NeuPomodoro
//
//  Created by Lynton Schoeman on 2023-04-19.
//

import SwiftUI

struct SettingsTabView: View {
    
    public enum TabBarPosition {
        case top
        case bottom
    }
    
    private let tabBarPosition: TabBarPosition
    private let tabText: [String]
    private let tabIconNames: [String]
    private let tabViews: [AnyView]

    @State var selection = 0
    
    public init(tabBarPosition: TabBarPosition, content: [(tabText: String, tabIconName: String, view: AnyView)]) {
        self.tabBarPosition = tabBarPosition
        self.tabText = content.map{ $0.tabText }
        self.tabIconNames = content.map{ $0.tabIconName }
        self.tabViews = content.map{ $0.view }
    }
    
    public var tabBar: some View {
        VStack {
            if (self.tabBarPosition == .bottom) {
                Divider()
            } else {
                // Covers weird transparent toolbar area on scroll up
                Color("BackgroundSecondary")
                    .ignoresSafeArea()
                    .frame(height: 10)
            }
            
            VStack {
                
                HStack {
                    Spacer()
                    
                    ForEach(tabText.indices, id:\.self) { index in
                        VStack {
                            Image(systemName: self.tabIconNames[index])
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text(self.tabText[index])
                                .font(.caption)
                        }
                        .padding(5)
                        .onTapGesture {
                            self.selection = index
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(Color.secondary.opacity(self.selection == index ? 0.15 : 0))
                        )
                    }
                    
                    Spacer()
                }
                
                if (self.tabBarPosition == .top) {
                    Divider()
                }
            }
            .padding(.top, self.tabBarPosition == .bottom ? 10 : 0)
        }
        .background(Color("BackgroundSecondary"))
    }
    
    public var body: some View {
        
        VStack(spacing: 0) {
            
            if (self.tabBarPosition == .top) {
                tabBar
            }
            
            tabViews[selection]
                .padding(0)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if (self.tabBarPosition == .bottom) {
                tabBar
            }
        }
        .padding(0)
    }
}

struct SettingsTabView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsTabView(
            tabBarPosition: .top,
            content: [
                (
                    tabText: "About",
                    tabIconName: "questionmark.circle",
                    view: AnyView(
                        HStack {
                            Spacer()
                            VStack {
                                Spacer()
                                Text("About!")
                                Spacer()
                            }
                            Spacer()
                        }
                        .background(Color.yellow)
                    )
                )
            ]
        )
    }
}
