//
//  Settings.swift
//  Wayfarer
//
//  Created by Franco Miguel Guevarra on 2/20/25.
//

import SwiftUI
import Sticker

struct Settings: View {

    @Environment(GameManager.self) var gameManager
    @State var audioManager = AudioManager.shared
    
    @State private var stickerWidth: CGFloat?
    @State private var stickerHeight: CGFloat?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image("settings_inset")
                .resizable()
                .aspectRatio(480/288, contentMode: .fit)
                .frame(width: stickerWidth ?? 480)
                .overlay(alignment: .bottom) {
                    VStack {
                        HStack {
                            Image("Settings_Reset")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 15)
                            
                            Button {
                                gameManager.reset()
                            } label: {
                                Image("Settings_ResetButton")
                                    .resizable()
                                    .frame(width: 22, height: 22)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                        .padding(.horizontal, 40)
                        
                        ZStack {
                            Image("sticker_bg")
                                .resizable()
                                .scaledToFit()
                            
                            Image("sticker_fg")
                                .resizable()
                                .scaledToFit()
                                .overlay {
                                    Rectangle()
                                        .fill(Color.white)
                                        .stickerEffect()
                                        .stickerColorIntensity(1.0)
                                        .stickerMotionEffect(.accelerometer)
                                        .blur(radius: 10)
                                        .mask {
                                            Image("sticker_fg")
                                                .resizable()
                                                .scaledToFit()
                                        }
                                }
                        }
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(18)
                }
                .padding(.bottom, stickerHeight ?? 75)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .overlay(alignment: .topLeading) {
            Key(.back) {
                gameManager.settingsOpen = false
            }
            .frame(width: 85, height: 85)
            .padding(15)
        }
        .background(alignment: .bottom) {
            Image("settings_ridges")
                .resizable()
                .scaledToFit()
                .padding(.vertical, 10)
                .overlay {
                    GeometryReader { geometry in
                        Color.clear
                            .task {
                                stickerWidth = geometry.size.width * 0.41
                                stickerHeight = geometry.size.height * 0.43
                            }
                    }
                }
        }
    }
    
    
}
