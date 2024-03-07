//
//  ContentView.swift
//  Ingridients
//
//  Created by M on 26/02/2023.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            //            NavigationStack {
            Group {
                ComparatorView()
                    .tabItem {
                        Label("Compare", systemImage: "list.dash")
                    }
                CheckerView()
                    .tabItem {
                        Label("Check", systemImage: "checklist")
                    }
            }
            .if(OS.isMacOS) {
                $0
                    .padding()
            }
            
            //                ProductsView()
            //                    .tabItem {
            //                        Label("Compare", systemImage: "checklist")
            //                    }
            //            }
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
