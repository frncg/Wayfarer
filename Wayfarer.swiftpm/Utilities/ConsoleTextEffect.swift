//
//  ConsoleTextEffect.swift
//  Wayfarer
//
//  Created by Franco Miguel Guevarra on 1/25/25.
//

import SwiftUI

struct ConsoleEffectRenderer: TextRenderer, Animatable {
    
    var phase: TimeInterval

    var letterDuration: TimeInterval
    
    @State var totalCount: Int = 0

    var animatableData: Double {
        get { phase }
        set { phase = newValue }
    }

    init(phase: TimeInterval, letterDuration: TimeInterval = 0.015) {
        self.phase = phase
        self.letterDuration = letterDuration
    }

    func draw(layout: Text.Layout, in context: inout GraphicsContext) {
        // Flatten all runs for easier access to individual characters
        let slices = layout.flattenedRunSlices
        let totalLetters = slices.count
        let totalDuration = Double(totalLetters) * letterDuration
        
        var lastVisibleSlice: Text.Layout.RunSlice?

        for (index, slice) in slices.enumerated() {
            let letterElapsedTime = phase * totalDuration

            if letterElapsedTime > Double(index) * letterDuration {
                var copy = context
                draw(slice, at: letterElapsedTime, in: &copy)
                lastVisibleSlice = slice
            }
        }
        
        if let lastVisibleSlice, phase < 1 {
            let cursorPosition = CGPoint(
                x: lastVisibleSlice.typographicBounds.rect.maxX + 5,
                y: lastVisibleSlice.typographicBounds.origin.y - lastVisibleSlice.typographicBounds.rect.height
            )
            
            let cursorSize = CGSize(width: 0, height: 0)

            context.draw(
                Text("▊"),
                in: CGRect(origin: cursorPosition, size: cursorSize)
            )
        }
    }

    func draw(_ slice: Text.Layout.RunSlice, at time: TimeInterval, in context: inout GraphicsContext) {
        if time >= 0 {
            context.opacity = 1.0
            context.draw(slice, options: .disablesSubpixelQuantization)
        }
    }
}

extension Text.Layout {
    var flattenedRuns: some RandomAccessCollection<Text.Layout.Run> {
        self.flatMap { line in
            line
        }
    }

    var flattenedRunSlices: some RandomAccessCollection<Text.Layout.RunSlice> {
        flattenedRuns.flatMap(\.self)
    }
}


struct ConsoleTransition: Transition {
    
    var count: Int
    var onCompletion: () -> Void
    
    init(count: Int, onCompletion: @escaping () -> Void = {}) {
        self.count = count
        self.onCompletion = onCompletion
    }

    static var properties: TransitionProperties {
        TransitionProperties(hasMotion: true)
    }

    func body(content: Content, phase: TransitionPhase) -> some View {
        let phase = phase.isIdentity ? 1 : 0
        let renderer = ConsoleEffectRenderer(
            phase: TimeInterval(phase),
            letterDuration: 0.015
        )

        content.transaction { transaction in
            transaction.animation = .linear(duration: TimeInterval(Double(count) * 0.015))
        } body: { view in
            view
                .textRenderer(renderer)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(Double(count) * 0.015) + 1.0) {
                        onCompletion()
                    }
                }
        }
    }
}
