//
//  Keys.swift
//  Wayfarer
//
//  Created by Franco Miguel Guevarra on 1/25/25.
//

import SwiftUI

struct Key: View {
    
    enum KeyType {
        case up, down, settings, enter, back
        
        var image: String {
            switch self {
            case .up:
                return "Up_Key"
            case .down:
                return "Down_Key"
            case .settings:
                return "Settings_Key"
            case .enter:
                return "Enter_Key"
            case .back:
                return "Back_Key"
            }
        }
        
        var housing: String {
            switch self {
            case .enter:
                return "Enter_Housing"
            default:
                return "Normal_Housing"
            }
        }
    }
    
    @Environment(GameManager.self) var gameManager
    @State var audioManager = AudioManager.shared
    @State private var isPressed: Bool = false
    
    var type: KeyType
    var onTap: () -> Void
    
    init(_ type: KeyType, onTap: @escaping () -> Void) {
        self.type = type
        self.onTap = onTap
    }
    
    var body: some View {
        ZStack {
            Image(type.housing)
                .resizable()
            
            Image(type.image)
                .resizable()
                .aspectRatio(type == .enter ? 113/77 : 1, contentMode: .fit)
                .brightness(isPressed ? -0.05 : 0)
                .padding(1)
                .opacity(gameManager.controlsEnabled ? 1 : 0.4)
                .scaleEffect(isPressed ? 0.98 : 1)
        }
        .aspectRatio(type == .enter ? 121/85 : 1, contentMode: .fit)
        .onLongPressGesture(minimumDuration: 0.01) {
            audioManager.playKeyPress()
            onTap()
            isPressed = true
        } onPressingChanged: { value in
            isPressed = value
        }
        .allowsHitTesting(gameManager.controlsEnabled)
            
    }
    
}

#Preview {
    
    Key(.up) {
    }
    
    Key(.down) {
    }

    Key(.settings) {
    }
    
    Key(.enter) {
    }


}
