//
//  ContentView.swift
//  Ingridients
//
//  Created by M on 26/02/2023.
//

import SwiftUI

struct ContentView: View {
    
    enum Action {
        case Compare
        case CheckAgainst
        case TescoShampoo
        
        var systemImage: String {
            switch self {
            case .Compare:
                return "checklist"
            case .CheckAgainst:
                return "checklist"
            case .TescoShampoo:
                return "checklist"
            }
        }
    }
    
    @State private var action = Action.Compare
    
    var body: some View {
        NavigationStack {
            Group{
                switch action {
                case .Compare:
                    ComparatorView()
                case .CheckAgainst:
                    CheckerView()
                case .TescoShampoo:
                    TescoShampooView()
                }
            }
            .if(OS.isMacOS) {
                $0
                    .padding()
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { toggleAction() }) {
                        Label("Look for", systemImage: action.systemImage)
                            .labelStyle(.iconOnly)
                    }
                }
            }
            
        }
    }
    
    private func toggleAction() {
        withAnimation {
            switch action {
            case .Compare:
                action = .CheckAgainst
            case .CheckAgainst:
                action = .TescoShampoo
            case .TescoShampoo:
                action = .Compare
            }
        }
    }
    
    func parseString(_ input: String, separators: CharacterSet = .whitespacesAndNewlines.union(.punctuationCharacters)) -> [String] {
        return input
            .components(separatedBy: separators)
            .filter { !$0.isEmpty }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
