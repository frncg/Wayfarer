//
//  Dialog.swift
//  Wayfarer
//
//  Created by Franco Miguel Guevarra on 1/25/25.
//

import Foundation
import SwiftUI

class Dialog: Equatable, @unchecked Sendable {
    let id = UUID()
    let elements: [DialogElement]
    let controls: DialogControls
    let sprites: [String]?
    
    init(elements: [DialogElement], controls: DialogControls, sprites: [String]? = nil) {
        self.elements = elements
        self.controls = controls
        self.sprites = sprites
    }
    
    static func == (lhs: Dialog, rhs: Dialog) -> Bool {
        lhs.id == rhs.id
    }
}

final class Message: Dialog, @unchecked Sendable { }

final class Puzzle: Dialog, @unchecked Sendable {

    let choices: [String]
    let correctIndex: Int
    
    init(
        elements: [DialogElement],
        sprites: [String]?,
        choices: [String],
        correctIndex: Int
    ) {
        self.choices = choices
        self.correctIndex = correctIndex
        super.init(elements: elements, controls: .puzzle, sprites: sprites)
    }
}



enum DialogControls: Equatable {
    case continueOnly
    case firstPage
    case middlePage
    case lastPage
    case puzzle
    case custom(String, TextAlignment)
    
    var string: String {
        switch self {
        case .continueOnly:
            """
            –––––––––––––––––––––––––––––––
            [ENTER] to continue
            """
        case .firstPage:
            """
            –––––––––––––––––––––––––––––––
            [↓] NEXT
            """
        case .middlePage:
            """
            –––––––––––––––––––––––––––––––
            [↑] BACK   [↓] NEXT
            """
        case .lastPage:
            """
            –––––––––––––––––––––––––––––––
            [↑] BACK  [ENTER] to start puzzle
            """
        case .puzzle:
            """
            –––––––––––––––––––––––––––––––
            [↑][↓] SELECT  [ENTER] to continue
            """
        case .custom(let string, _):
            """
            ––––––––––––––––––––
            \(string)
            """
        }
    }
}

struct Section: Sendable {
    var title: String
    var dialogs: [Dialog]
}
