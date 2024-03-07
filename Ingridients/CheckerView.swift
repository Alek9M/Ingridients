//
//  CheckerView.swift
//  Ingridients
//
//  Created by M on 27/02/2023.
//

import SwiftUI

struct CheckerView: View {
    
    @State private var ingridientsRaw = ""
    @State private var settings = false
    
    
    private var content: some View {
        Group {
            IngridientsSection(title: "Ingridients", ingridientsRaw: $ingridientsRaw)
            
            if OS.isMacOS{
                HStack {
                    lists
                }
            } else {
                lists
            }
            
        }
    }
    
    private var lists: some View {
        Group {
            HighlightedAddableListSection(title: "Should be present", color: .green, isHighlighted: found)
            HighlightedAddableListSection(title: "Avoid", color: .red, isHighlighted: found)
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if OS.isMacOS {
                    ScrollView {
                        content
                        Spacer()
                    }
                } else {
                    Form {
                        content
                    }
                }
            }
            .if(!OS.isMacOS){
                $0
                    .navigationTitle("Check against")
                    .settings(areShown: $settings)
            }
            
        }
        
    }
    
    private func found(_ ingridient: String) -> Bool {
        return contains(ingridient) || similar(ingridient)
    }
    
    private func contains(_ ingridient: String) -> Bool {
        return ingridientsRaw.parsedIngridients.contains { $0.lowercased() == ingridient.lowercased() }
    }
    
    private func similar(_ ingridient: String) -> Bool {
        return ingridientsRaw.parsedIngridients.contains { raw in
            let rawLow = raw.lowercased()
            let ingLow = ingridient.lowercased()
            return rawLow.hasPrefix(ingLow) || rawLow.hasSuffix(ingLow) }
    }
}

struct CheckerView_Previews: PreviewProvider {
    static var previews: some View {
        CheckerView()
    }
}
