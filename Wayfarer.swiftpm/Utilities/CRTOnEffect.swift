//
//  CRTOnEffect.swift
//  Wayfarer
//
//  Created by Franco Miguel Guevarra on 2/21/25.
//

import SwiftUI

struct CRTOnEffect: ViewModifier {
    
    @Environment(GameManager.self) var gameManager
    @State var audioManager = AudioManager.shared
    
    @State var horizontalScale: Double = 0.0
    @State var verticalScale: Double = 0.0
    @State var phase: Double = 0.0
    @State var opacity: Double = 1.0
    
    @State var flash: Bool = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(x: horizontalScale, y: verticalScale, anchor: .center)
            //.blur(radius: 10 - (phase * 10))
            .overlay {
                Color.white
                    .scaleEffect(x: horizontalScale, y: verticalScale, anchor: .center)
                    .opacity(opacity)
            }
            .overlay {
                TimelineView(.animation) { context in
                    Color.gray
                        .colorEffect(ShaderLibrary.noise(.float(context.date.timeIntervalSinceNow)))
                        .opacity(flash ? 1 : 0.1)
                }
            }
            .animation(.snappy(duration: 0.2), value: horizontalScale)
            .animation(.snappy(duration: 0.2), value: verticalScale)
            .animation(.snappy(duration: 0.2), value: phase)
            .animation(.snappy(duration: 0.2), value: opacity)
            .onAppear {
                if gameManager.currentSprites != nil {
                    openAnimation()
                }
            }
            .onChange(of: gameManager.currentSprites) { oldValue, newValue in
                if oldValue == nil, newValue != nil {
                    audioManager.playTVEffect()
                    openAnimation()
                } else if oldValue != nil, newValue == nil {
                    closeAnimation()
                }
            }
            .onChange(of: gameManager.currentDialog()) { oldValue, newValue in
                if oldValue.sprites != nil && newValue.sprites != nil && oldValue.sprites != newValue.sprites {
                    flash = true
                    audioManager.playTVEffect(switchChannel: true)
                    withAnimation(.snappy(duration: 0.6)) {
                        flash = false
                    }
                }
            }
    }
    
    func openAnimation() {
        horizontalScale = 0.0
        verticalScale = 0.0
        phase = 0.0
        opacity = 1.0
        
        Task { @MainActor in
            try await Task.sleep(nanoseconds: 100_000_000)
            verticalScale = 0.02
            horizontalScale = 1.0
            try await Task.sleep(nanoseconds: 200_000_000)
            verticalScale = 1.0
            opacity = 0.0
            phase = 1.0
        }
    }
    
    func closeAnimation() {
        horizontalScale = 1.0
        verticalScale = 1.0
        phase = 1.0
        opacity = 0.0
        
        Task { @MainActor in
            try await Task.sleep(nanoseconds: 100_000_000)
            verticalScale = 0.02
            opacity = 1.0
            phase = 0.0
            try await Task.sleep(nanoseconds: 200_000_000)
            verticalScale = 0
            horizontalScale = 0
        }
    }
}

