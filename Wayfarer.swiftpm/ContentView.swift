import SwiftUI
import ConfettiSwiftUI

struct ContentView: View {
   
    @State var gameManager = GameManager()
    @State var audioManager = AudioManager()
    
    @State private var confetti = false
    
    var body: some View {

        ZStack {
            if !gameManager.settingsOpen {
                mainView
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
            } else {
                Settings()
                    .transition(.opacity.combined(with: .move(edge: .leading)))
            }
        }
        .animation(.spring(), value: gameManager.settingsOpen)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Image("BG")
                .resizable()
                .ignoresSafeArea()
        }
        .overlay(alignment: .top) {
            Color.clear
                .frame(height: 10, alignment: .top)
                .confettiCannon(
                    trigger: $confetti,
                    num: 100,
                    rainHeight: 400,
                    openingAngle: .degrees(180),
                    closingAngle: .degrees(360),
                    radius: 600
                )
        }
        .environment(gameManager)
        .environment(audioManager)
        .onAppear {
            audioManager.startMusic()
        }
        .onChange(of: gameManager.currentSectionIndex) { oldValue, newValue in
            if newValue == GameSections.all.count - 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    confetti.toggle()
                }
            }
        }
    }
    
    @ViewBuilder
    var mainView: some View {
        VStack {
            GeometryReader { geometry in
                HStack(alignment: .top, spacing: 5) {
                    Game()
                        .frame(width: geometry.size.width * 0.61, alignment: .leading)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Console()
                            .frame(maxWidth: .infinity, alignment: .top)
                            .layoutPriority(1)
                            .frame(maxHeight: .infinity, alignment: .top)
                        
                        HStack {
                            Group {
                                Key(.settings) {
                                    gameManager.settingsOpen = true
                                }
                                
                                Spacer()
                                
                                Key(.up) {
                                    gameManager.selectPreviousOption()
                                }
                                
                                Key(.down) {
                                    gameManager.selectNextOption()
                                }
                                
                                
                                Key(.enter) {
                                    Task {
                                        await gameManager.pressEnter()
                                    }
                                }
                                .aspectRatio(121/85, contentMode: .fill)
                                .layoutPriority(1)
                            }
                            .frame(maxHeight: .infinity)
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(minHeight: 77, maxHeight: 85, alignment: .bottom)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .aspectRatio(1176/590, contentMode: .fit)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal)
            
            Spacer()
            
            Image("Logo")
                .resizable()
                .scaledToFit()
                .padding(.vertical, 10)
        }
    }
}

