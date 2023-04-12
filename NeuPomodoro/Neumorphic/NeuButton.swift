//
//  NeuButton.swift
//  NeuPomodoro
//
//  Created by Lynton Schoeman on 2023-04-10.
//

import SwiftUI

struct NeuButton: View {
    let imageName: String
    let shape: AnyShape
    var width = 30.0
    var height = 30.0
    let action: () -> Void
    @State private var isPressed = false
    @State private var offset: CGFloat = 0.0

    var body: some View {
        Button(action: action) {
            Image(systemName: imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: min(self.width, 15), height: min(self.height, 15))    // Setting a limit on how big the button image can be.
                        .offset(x: offset, y: offset)
        }
        .modifier(PressActions(onPress: {
            isPressed = true
            offset = -2.0
        }, onRelease: {
            isPressed = false
            offset = 0.0
        }))
        .buttonStyle(NeuButtonStyle(shape: AnyShape(Circle()), width: self.width, height: self.height))
    }
}

struct PressActions: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in
                        onPress()
                    })
                    .onEnded({ _ in
                        onRelease()
                    })
            )
    }
}

struct AnyShape: Shape {
    init<S: Shape>(_ wrapped: S) {
        _path = { rect in
            let path = wrapped.path(in: rect)
            return path
        }
    }

    func path(in rect: CGRect) -> Path {
        return _path(rect)
    }

    private let _path: (CGRect) -> Path
}

struct NeuButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    var shape: AnyShape
    var width = 30.0
    var height = 30.0
    
    func makeBody(configuration: Self.Configuration) -> some View {
        if (colorScheme == .dark) {
            configuration.label
                .padding(EdgeInsets(top: height, leading: width, bottom: height, trailing: width))
                .contentShape(shape)
                .background(
                    DarkBackground(isHighlighted: configuration.isPressed, shape: shape)
                )
                .foregroundColor(.white)
        } else
        {
            configuration.label
                .padding(EdgeInsets(top: height, leading: width, bottom: height, trailing: width))
                .contentShape(shape)
                .background(
                    LightBackground(isHighlighted: configuration.isPressed, shape: shape)
                )
        }
    }
}

struct LightBackground<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S
    
    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(LinearGradient(Color.lightEnd, Color.lightStart))
                    .overlay(shape.stroke(LinearGradient(Color.lightStart, Color.lightEnd), lineWidth: 1).opacity(0.5))
                    .shadow(color: Color.lightStart, radius: 5, x: 5, y: 5)
                    .shadow(color: Color.lightEnd, radius: 5, x: -5, y: -5)
                    .blur(radius: 5, opaque: false)

            } else {
                shape
                    .fill(LinearGradient(Color.lightStart, Color.lightEnd))
                    .overlay(shape.stroke(Color.lightEnd, lineWidth: 1).opacity(0.5))
                    .shadow(color: Color.lightStart, radius: 5, x: -10, y: -10)
                    .shadow(color: Color.lightEnd, radius: 5, x: 10, y: 10)
                    .blur(radius: 5, opaque: false)
            }
        }
    }
}

struct DarkBackground<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S

    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(LinearGradient(Color.darkEnd, Color.darkStart))
                    .overlay(shape.stroke(LinearGradient(Color.darkStart, Color.darkEnd), lineWidth: 1).opacity(0.5))
                    .shadow(color: Color.darkStart, radius: 5, x: 5, y: 5)
                    .shadow(color: Color.darkEnd, radius: 5, x: -5, y: -5)
                    .blur(radius: 5, opaque: false)

            } else {
                shape
                    .fill(LinearGradient(Color.darkStart, Color.darkEnd))
                    .overlay(shape.stroke(Color.darkEnd, lineWidth: 1).opacity(0.5))
                    .shadow(color: Color.darkStart, radius: 5, x: -10, y: -10)
                    .shadow(color: Color.darkEnd, radius: 5, x: 10, y: 10)
                    .blur(radius: 5, opaque: false)
            }
        }
    }
}
