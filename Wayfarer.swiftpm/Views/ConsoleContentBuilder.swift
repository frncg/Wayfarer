//
//  ConsoleContentBuilder.swift
//  Wayfarer
//
//  Created by Franco Miguel Guevarra on 2/21/25.
//

import SwiftUI

struct ConsoleContentBuilder: View {

    @Environment(GameManager.self) var gameManager
    @Environment(AudioManager.self) private var audioManager
    @Environment(\.tint) var tint
    
    private let startDate = Date.now
    
    let dialog: Dialog
    
    init(_ dialog: Dialog) {
        self.dialog = dialog
    }
    
    @State private var shownElements: [DialogElement] = []
    @State private var showControls: Bool = false
    @State private var shake: Bool = false
    @State private var previouslyShown: Bool = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            GeometryReader { geometry in
                VStack(alignment: .leading, spacing: 15) {
                    let random = Bool.random() ? CGFloat.random(in: -15 ... -5) : CGFloat.random(in: 5 ... 15)
                    
                    consoleBody
                        .offset(x: shake ? random : 0, y: shake ? random : 0)
                        .onChange(of: gameManager.state) { oldValue, newValue in
                            shake = false
                            if newValue == .error {
                                shake = true
                                withAnimation(.spring(response: 0.1, dampingFraction: 0.1, blendDuration: 0.2)) {
                                    shake = false
                                }
                            }
                        }
                }
                .shadow(color: tint.opacity(0.6), radius: 6)
                .padding(20)
                .font(.system(.subheadline, design: .monospaced))
                .lineSpacing(0)
                .monospaced()
                .foregroundColor(tint)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .background {
                    tint.opacity(0.15)
                }
                .task {
                    if gameManager.shownDialogs.contains(where: { $0 == dialog }) && dialog is Message {
                        previouslyShown = true
                        showControls = true
                        shownElements = dialog.elements
                        gameManager.controlsEnabled = true
                        return
                    }
                    
                    gameManager.controlsEnabled = false
                    try? await Task.sleep(nanoseconds: 1_500_000_000)
                    
                    if !dialog.elements.isEmpty {
                        shownElements.append(dialog.elements[0])
                    }
                }
                .overlay {
                    if gameManager.isLoading {
                        loadingScreen
                    }
                }
                .layerEffect(
                    ShaderLibrary.crtEffect(
                        .float(-startDate.timeIntervalSinceNow),
                        .float2(geometry.size)
                    ),
                    maxSampleOffset: .zero
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)

    }
    
    @ViewBuilder
    var consoleBody: some View {
        VStack(alignment: .leading, spacing: 15) {
            let zipped = Array(zip(shownElements.indices, shownElements))
            ForEach(zipped, id: \.0) { index, element in
                
                if let dialogLogo = element as? DialogLogo {
                    Text(dialogLogo.text)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .scaledToFit()
                        .minimumScaleFactor(0.5)
                        .doIf(!previouslyShown) { content in
                            content
                                .onAppear {
                                    audioManager.playDialogBeep(count: dialogLogo.text.count)
                                }
                                .transition(
                                    ConsoleTransition(count: dialogLogo.text.count) {
                                        showNextElement(currentIndex: index)
                                    }
                                )
                        }
                }
                
                if let dialogText = element as? DialogText {
                    Text(dialogText.text)
                        .fontWeight(dialogText.fontWeight)
                        .multilineTextAlignment(dialogText.alignment)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .doIf(!previouslyShown) { content in
                            content
                                .onAppear {
                                    audioManager.playDialogBeep(count: dialogText.text.count)
                                }
                                .transition(
                                    ConsoleTransition(count: dialogText.text.count) {
                                        showNextElement(currentIndex: index)
                                    }
                                )
                        }
                    
                }
                
                if element is PuzzleOptions,
                   let puzzle = dialog as? Puzzle,
                   let selectedOption = gameManager.selectedOption
                {
                    PuzzleChoiceView(puzzle: puzzle, selectedOption: selectedOption) {
                        showNextElement(currentIndex: index)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .layoutPriority(1)
        
        if showControls {
            Group {
                switch dialog.controls {
                case .custom(let string, let alignment):
                    Text(string)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(alignment)
                default:
                    Text(dialog.controls.string)
                }
            }
            .doIf(!previouslyShown) { content in
                content
                    .onAppear {
                        audioManager.playDialogBeep(count: dialog.controls.string.count)
                        if !gameManager.shownDialogs.contains(where: { $0 == dialog }) {
                            gameManager.shownDialogs.append(dialog)
                        }
                    }
                    .transition(
                        ConsoleTransition(count: dialog.controls.string.count) {
                            gameManager.controlsEnabled = true
                        }
                    )
            }
            .frame(maxHeight: .infinity, alignment: .bottomLeading)
        }
    }
    
    @ViewBuilder
    var loadingScreen: some View {
        let frames = ["𓃉𓃉𓃉", "𓃉𓃉∘", "𓃉∘°", "∘°∘", "°∘𓃉", "∘𓃉𓃉"]
        TimelineView(.animation(minimumInterval: 0.05)) { timeline in
            let frameIndex = Int(timeline.date.timeIntervalSinceReferenceDate * 10) % frames.count
            
            Text(frames[frameIndex])
                .font(.largeTitle)
                .monospaced()
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundStyle(tint)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.black.opacity(0.9)
            
            tint
              .opacity(0.2)
        }
    }
    
    func showNextElement(currentIndex: Int) {
        guard !previouslyShown else {
            return
        }
        
        guard currentIndex + 1 < dialog.elements.count else {
            showControls = true
            return
        }
        
        let nextElement = dialog.elements[currentIndex + 1]
        shownElements.append(nextElement)
    }
}
