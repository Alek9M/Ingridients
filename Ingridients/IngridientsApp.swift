//
//  IngridientsApp.swift
//  Ingridients
//
//  Created by M on 26/02/2023.
//

import SwiftUI
import SwiftData

@main
struct IngridientsApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Ingridients.self, Ingridient.self])
    }
}
