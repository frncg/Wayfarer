//
//  Console.swift
//  Wayfarer
//
//  Created by Franco Miguel Guevarra on 1/14/25.
//

import SwiftUI
import ConfettiSwiftUI

struct Console: View {
    
    @Environment(GameManager.self) var gameManager
    
    var body: some View {
        Image("ConsoleFrame")
            .resizable()
            .scaledToFit()
            .aspectRatio(452/489, contentMode: .fit)

            .background {
                ConsoleContentBuilder(gameManager.currentSection().dialogs[gameManager.currentDialogIndex])
                    .aspectRatio(426/442, contentMode: .fill)
                    .overlay {
                        Image("ConsoleGlass")
                            .resizable()
                    }
                    .padding([.top, .horizontal], 11)
                    .padding([.bottom], 32)
                    .id("\(gameManager.currentSectionIndex)-\(gameManager.currentDialogIndex)")
                    .environment(\.tint, gameManager.state.color)
            }
            .background {
                Color.black
                    .clipShape(.rect(cornerRadius: 20))
            }
    }
    
}
