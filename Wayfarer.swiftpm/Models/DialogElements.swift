//
//  DialogElements.swift
//  Wayfarer
//
//  Created by Franco Miguel Gueletra on 2/21/25.
//

import SwiftUI

class DialogElement: Identifiable, Equatable {
    let id = UUID()
    
    static func == (lhs: DialogElement, rhs: DialogElement) -> Bool {
        lhs.id == rhs.id
    }
}

final class PuzzleOptions: DialogElement {}

final class DialogLogo: DialogElement {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
}

final class DialogText: DialogElement {
    let text: String
    let fontWeight: Font.Weight
    let alignment: TextAlignment
    
    init(_ text: String, fontWeight: Font.Weight = .medium, alignment: TextAlignment = .leading) {
        self.text = text
        self.fontWeight = fontWeight
        self.alignment = alignment
    }
}
