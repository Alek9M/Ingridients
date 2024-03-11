//
//  ViewModifiers.swift
//  Ingridients
//
//  Created by M on 07/03/2024.
//

import SwiftUI

public extension View {
    
    @ViewBuilder func settings(areShown: Binding<Bool>) -> some View {
        self
            .toolbar {
                ToolbarItem {
                    Button(action: {areShown.wrappedValue.toggle()}, label: {
                        Label("Settings", systemImage: "gear")
                    })
                    
                }
            }
            .sheet(isPresented: areShown, content: {
                SettingsView()
            })
    }
    
    @ViewBuilder func progress(isOn: Bool) -> some View {
        self
            .toolbar {
                ToolbarItem {
                    if isOn {
                        ProgressView()
                          .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                          .if(OS.isMacOS) {
                              $0.scaleEffect(0.6, anchor: .center)
                          }
                    }
                }
            }
    }
}
