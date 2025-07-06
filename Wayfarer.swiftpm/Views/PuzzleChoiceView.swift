//
//  PuzzleChoiceView.swift
//  Wayfarer
//
//  Created by Franco Miguel Guevarra on 2/21/25.
//

import SwiftUI

struct PuzzleChoiceView: View {
    
    @Environment(GameManager.self) var gameManager
    @State var audioManager = AudioManager.shared
    @Environment(\.tint) var tint
    
    let puzzle: Puzzle
    let selectedOption: Int
    var onCompletion: () -> Void
    
    @State private var blink: Bool = false
    
    @State private var shownChoices: [String] = []
    
    var body: some View {
        let zipped = Array(zip(shownChoices.indices, shownChoices))
        VStack(spacing: 5) {
            ForEach(zipped, id: \.0) { choiceIndex, choice in
                Text(choice)
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.footnote)
                    .fontWeight(selectedOption == choiceIndex ? .bold : .medium)
                    .foregroundStyle(selectedOption == choiceIndex ? Color.black : tint)
                    .background(selectedOption == choiceIndex ? tint : Color.clear)
                    .multilineTextAlignment(.center)
                    .border(tint, width: selectedOption != choiceIndex ? 1.5 : 0)
                    .onAppear {
                        audioManager.playDialogBeep(count: 1)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showNextChoice(currentIndex: choiceIndex)
                        }
                    }
                    .opacity(blink && selectedOption == choiceIndex ? 0 : 1)
                    .opacity(gameManager.state == .correct && selectedOption != choiceIndex ? 0 : 1)
                    .onChange(of: gameManager.state) {
                        if gameManager.state == .correct {
                            blink = true
                            withAnimation(.linear(duration: 0.02).repeatCount(15, autoreverses: true)) {
                                blink = false
                            }
                        }
                    }
            }
        }
        .onShake {
            gameManager.exitPuzzle()
        }
        .task {
            if !puzzle.choices.isEmpty {
                shownChoices.append(puzzle.choices[0])
            }
        }
    }
    
    func showNextChoice(currentIndex: Int) {
        guard currentIndex + 1 < puzzle.choices.count else {
            onCompletion()
            return
        }
        
        let nextElement = puzzle.choices[currentIndex + 1]
        shownChoices.append(nextElement)
    }
}
