//
//  IngridientsSection.swift
//  Ingridients
//
//  Created by M on 26/02/2023.
//

import SwiftUI

struct IngridientsSection: View {
    
    let title: String
    
    @Binding var ingridientsRaw: String
    
    @State private var detailed = false
    
    private var content: some View {
        Group {
            TextEditor(text: $ingridientsRaw)
            
            if detailed {
                ForEach(ingridientsRaw.parsedIngridients) { ingridient in
                    Text(ingridient.description.presentable)
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    private var header: some View {
        HStack {
            Text(title)
                .if(OS.isMacOS) {
                    $0.font(.headline)
                }
            Spacer()
            Button(action: { withAnimation { detailed.toggle() } }) {
                Label(detailed ? "hide" : "show", systemImage: detailed ? "chevron.down" : "chevron.right")
                    .labelStyle(.iconOnly)
            }
            .if(OS.isMacOS) {
                $0
                    .buttonStyle(.borderless)
            }
        }
    }
    
    var body: some View {
        if OS.isMacOS {
            VStack {
                header
                content
            }
            .frame(minHeight: 100, maxHeight: 200)
        } else {
            Section {
                content
            } header: {
                header
            }
        }
    }
}

struct IngridientsSection_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            IngridientsSection(title: "A", ingridientsRaw: .constant("wheat, rye, water"))
        }
    }
}
