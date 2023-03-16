//
//  ConditionalModifiers.swift
//  Ingridients
//
//  Created by M on 27/02/2023.
//

import Foundation
import SwiftUI

public extension View {
    
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    @ViewBuilder func modifierIf<T: ViewModifier>(_ condition: Bool, _ modifier: T) -> some View {
        if condition {
            self.modifier(modifier)
        } else {
            self
        }
    }
    
    func modifierIfNot<T: ViewModifier>(_ condition: Bool, _ modifier: T) -> some View {
        modifierIf(!condition, modifier)
    }
    
    @ViewBuilder func modifierIfElse<T_IF: ViewModifier, T_ELSE: ViewModifier>(_ condition: Bool, _ modifierIf: T_IF, _ modifierElse: T_ELSE) -> some View {
        if condition {
            self.modifier(modifierIf)
        } else {
            self.modifier(modifierElse)
        }
    }
    
    @ViewBuilder func orSpacer(_ condition: Bool) -> some View {
        if condition {
            self
        } else {
            Spacer()
        }
    }
}
