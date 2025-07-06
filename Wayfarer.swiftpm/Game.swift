//
//  Game.swift
//  Wayfarer
//
//  Created by Franco Miguel Guevarra on 1/25/25.
//


import SwiftUI
import ConfettiSwiftUI

struct Game: View {
    
    @Environment(GameManager.self) var gameManager
    let startDate = Date()
    
    @State private var confetti: Bool = false

    var body: some View {
        GeometryReader { geometry in
            Image("GameFrame")
                .resizable()
                .aspectRatio(708/590, contentMode: .fit)
                .background {
                    Color.black
                        .aspectRatio(684/543, contentMode: .fill)
                        .overlay {
                            TimelineView(.animation(minimumInterval: 2)) { timeline in
                                if let sprites = gameManager.currentSprites {
                                    let spriteIndex = Int(timeline.date.timeIntervalSinceReferenceDate / 2) % sprites.count
                                    Image(sprites[spriteIndex])
                                        .resizable()
                                        
                                } else {
                                    Color.black
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .modifier(CRTOnEffect())
                            .layerEffect(
                                ShaderLibrary.crtEffect(
                                    .float(-startDate.timeIntervalSinceNow),
                                    .float2(geometry.size)
                                ),
                                maxSampleOffset: .zero
                            )
                            .overlay(alignment: .bottom) {
                                Color.clear
                                    .frame(height: 10, alignment: .bottom)
                                    .confettiCannon(
                                        trigger: $confetti,
                                        num: 70,
                                        rainHeight: 200,
                                        openingAngle: .degrees(40),
                                        closingAngle: .degrees(140),
                                        radius: 500
                                    )
                                    .onChange(of: gameManager.state) {
                                        if gameManager.state == .correct {
                                            confetti.toggle()
                                        }
                                    }
                                    .layerEffect(ShaderLibrary.pixellate(.float(3)), maxSampleOffset: .zero)
                            }
                            
                            Image("ConsoleGlass")
                                .resizable()
                        }
                        .clipped()
                        .padding([.top, .horizontal], 10)
                        .padding([.bottom], 35)
                }
        }
    }
    
}
