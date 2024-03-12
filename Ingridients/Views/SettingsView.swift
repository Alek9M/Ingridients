//
//  SettingsView.swift
//  Ingridients
//
//  Created by M on 07/03/2024.
//

import SwiftUI

enum CloudDefaults: String {
    case api = "api"
    
    var description: String {
        switch self {
        case .api:
            return "API key"
        }
    }
}

struct SettingsView: View {
    
    @State private var apiText: String = ""
    
    init() {
        // Load initial value from storage
        _apiText = State(initialValue: CloudDefaults.api.rawValue.fromCloud)
    }
    
    private func cloudDefaultField(_ cloudDefault: CloudDefaults, _ bind: Binding<String>) -> some View {
        
        SecureField(cloudDefault.description, text: bind)
            .onChange(of: bind.wrappedValue) { newValue in
                // Save changes to NSUbiquitousKeyValueStore
                NSUbiquitousKeyValueStore.default.set(newValue, forKey: CloudDefaults.api.rawValue)
            }
            
    }
    
    private var content: some View {
        Form {
            Section("OpenAI") {
                cloudDefaultField(CloudDefaults.api, $apiText)
            }
        }
    }
    
    
    var body: some View {
        if OS.isMacOS {
            content
                .padding()
                .frame(minWidth: 500)
        } else {
            NavigationView {
                content
                    .navigationTitle("Settings")
            }
        }
    }
}

#Preview {
    SettingsView()
}
