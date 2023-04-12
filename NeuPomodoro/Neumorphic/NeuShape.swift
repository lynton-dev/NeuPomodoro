//
//  NeuShape.swift
//  NeuPomodoro
//
//  Created by Lynton Schoeman on 2023-04-10.
//

import SwiftUI

struct NeuShape<S: Shape>: View {
    @Environment(\.colorScheme) var colorScheme
    var isHighlighted: Bool
    var shape: S
    
    var body: some View {
        if (colorScheme == .dark) {
            DarkShape(isHighlighted: self.isHighlighted, shape: self.shape)
        } else {
            LightShape(isHighlighted: self.isHighlighted, shape: self.shape)
        }
    }
}

private struct LightShape<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S

    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(Color("Background"))
                    .shadow(color: Color.lightStart, radius: 5, x: 5, y: 5)
                    .shadow(color: Color.lightEnd, radius: 5, x: -5, y: -5)
                    .blur(radius: 3, opaque: false)

            } else {
                shape
                    .fill(Color("Background"))
                    .shadow(color: Color.lightStart, radius: 5, x: -10, y: -10)
                    .shadow(color: Color.lightEnd, radius: 5, x: 10, y: 10)
                    .blur(radius: 3, opaque: false)
            }
        }
    }
}

private struct DarkShape<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S

    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(Color("Background"))
                    .shadow(color: Color.darkStart, radius: 5, x: 5, y: 5)
                    .shadow(color: Color.darkEnd, radius: 5, x: -5, y: -5)
                    .blur(radius: 3, opaque: false)

            } else {
                shape
                    .fill(Color("Background"))
                    .shadow(color: Color.darkStart, radius: 5, x: -5, y: -5)
                    .shadow(color: Color.darkEnd, radius: 5, x: 5, y: 5)
                    .blur(radius: 3, opaque: false)
            }
        }
    }
}
