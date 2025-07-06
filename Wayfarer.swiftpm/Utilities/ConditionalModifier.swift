//
//  ConditionalModifier.swift
//  Wayfarer
//
//  Created by Franco Miguel Guevarra on 2/17/25.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    func doIf<Content: View>(_ condition: Bool, then content: (Self) -> Content) -> some View {
        if condition {
            content(self)
        } else {
            self
        }
    }
    
}
