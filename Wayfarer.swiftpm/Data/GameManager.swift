//
//  GameManager.swift
//  Wayfarer
//
//  Created by Franco Miguel Guevarra on 1/25/25.
//

import Foundation
import SwiftUI

@MainActor
@Observable
class GameManager {

    @ObservationIgnored private var audioManager = AudioManager.shared
    
    var controlsEnabled: Bool = true
    var finishedOnboarding: Bool = false {
        didSet {
            UserDefaults.standard.set(finishedOnboarding, forKey: "finishedOnboarding")
        }
    }
    var settingsOpen: Bool = false
    private(set) var isLoading: Bool = false
    var state: GameState = .normal {
        didSet {
            switch state {
            case .normal:
                controlsEnabled = true
            case .error:
                controlsEnabled = false
                audioManager.playDialogEffect(.dialogWrong)
            case .correct:
                controlsEnabled = false
                audioManager.playDialogEffect(.dialogCorrect)
            }
        }
    }

    private(set) var currentSectionIndex: Int = 0 {
        didSet {
            UserDefaults.standard.set(currentSectionIndex, forKey: "currentSectionIndex")
        }
    }
    var currentDialogIndex: Int = 0 {
        didSet {
            UserDefaults.standard.set(currentDialogIndex, forKey: "currentDialogIndex")
            
            if currentSection().dialogs[currentDialogIndex] is Puzzle {
                selectedOption = 0
            } else {
                selectedOption = nil
            }
            
            currentSprites = currentDialog().sprites
        }
    }
    private(set) var selectedOption: Int?
    private(set) var currentSprites: [String]?
    
    var shownDialogs: [Dialog] = [] {
        didSet {
            let ids: [String] = shownDialogs.compactMap { dialog in
                if let section = GameSections.all.first(where: { $0.dialogs.contains(dialog) }),
                   let index = section.dialogs.firstIndex(of: dialog) {
                    return "\(section.title)_\(index)"
                }
                return nil
            }
            UserDefaults.standard.set(ids, forKey: "shownDialogs")
        }
    }
        
    init() {
        finishedOnboarding = UserDefaults.standard.bool(forKey: "finishedOnboarding")
        
        if let savedIds = UserDefaults.standard.array(forKey: "shownDialogs") as? [String] {
            DispatchQueue.main.async { [weak self] in
                self?.shownDialogs = savedIds.compactMap { id in
                    let components = id.components(separatedBy: "_")
                    if components.count == 2, let section = GameSections.all.first(where: { $0.title == components[0] }), let index = Int(components[1]) {
                        return section.dialogs[index]
                    }
                    return nil
                }
                
                self?.currentSectionIndex = UserDefaults.standard.integer(forKey: "currentSectionIndex")
                self?.currentDialogIndex = UserDefaults.standard.integer(forKey: "currentDialogIndex")
            }
        } else {
            currentSectionIndex = UserDefaults.standard.integer(forKey: "currentSectionIndex")
            currentDialogIndex = UserDefaults.standard.integer(forKey: "currentDialogIndex")
        }
        
    }
    
    func pressEnter() async {
        if let puzzle = currentDialog() as? Puzzle {
            state = .normal
            audioManager.playDialogEffect(.dialogLoad)
            
            isLoading = true
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            isLoading = false
            
            if puzzle.correctIndex != selectedOption {
                state = .error
                try? await Task.sleep(nanoseconds: 2_500_000_000)
                state = .normal
            } else {
                state = .correct
                try? await Task.sleep(nanoseconds: 2_500_000_000)
                state = .normal
                nextPage()
            }
        } else {
            switch currentDialog().controls {
            case .continueOnly, .custom(_, _), .lastPage:
                nextPage()
            default:
                break
            }
        }
    }
    
    func previousPage() {
        audioManager.playDialogEffect(.dialogBeep)
        if currentDialogIndex > 0 {
            currentDialogIndex -= 1
        }
    }
    
    func nextPage() {
        audioManager.playDialogEffect(.dialogBeep)
        if currentDialogIndex < currentSection().dialogs.count - 1 {
            currentDialogIndex += 1
        } else {
            if let index = GameSections.all.firstIndex(where: { $0.title == currentSection().title }), GameSections.all.indices.contains(index + 1)  {
                currentSectionIndex = index + 1
                currentDialogIndex = 0
            }
        }
    }

    func selectPreviousOption() {
        if let selectedOption, let puzzle = currentDialog() as? Puzzle {
            audioManager.playDialogEffect(.dialogBeep)
            if puzzle.choices.indices.contains(selectedOption - 1) {
                self.selectedOption = selectedOption - 1
            } else {
                self.selectedOption = puzzle.choices.count - 1
            }
        } else {
            switch currentDialog().controls {
            case .middlePage, .lastPage:
                previousPage()
            default:
                audioManager.playDialogEffect(.dialogNext)
            }
        }
    }
    
    func selectNextOption() {
        if let selectedOption, let puzzle = currentDialog() as? Puzzle {
            audioManager.playDialogEffect(.dialogBeep)
            if puzzle.choices.indices.contains(selectedOption + 1) {
                self.selectedOption = selectedOption + 1
            } else {
                self.selectedOption = 0
            }
        } else {
            switch currentDialog().controls {
            case .firstPage, .middlePage, .custom(_, _):
                nextPage()
            default:
                audioManager.playDialogEffect(.dialogNext)
            }
        }
    }
    
    func currentSection() -> Section {
        GameSections.all[currentSectionIndex]
    }
    
    func currentDialog() -> Dialog {
        currentSection().dialogs[currentDialogIndex]
    }
    
    func exitPuzzle() {
        guard state == .normal && !settingsOpen && !isLoading else {
            return
        }
        
        Task { @MainActor in
            audioManager.playDialogEffect(.dialogLoad)
            isLoading = true
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            isLoading = false
            currentDialogIndex = 0
            audioManager.playDialogEffect(.dialogBeep)
        }
    }
    
    func reset() {
        currentSectionIndex = 0
        currentDialogIndex = 0
        shownDialogs = []
        settingsOpen = false
    }
}

extension GameManager {
    enum GameState {
        case normal
        case error
        case correct

        
        var color: Color {
            switch self {
            case .normal:
                return .yellow
            case .error:
                return .red
            case .correct:
                return .green
            }
        }
    }
}
