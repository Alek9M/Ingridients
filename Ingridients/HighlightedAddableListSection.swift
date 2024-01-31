//
//  HighlitedAddableListSection.swift
//  Ingridients
//
//  Created by M on 27/02/2023.
//

import SwiftUI

struct HighlightedAddableListSection: View {
    
    @State private var ingridients: [String] = []
    @State private var ingridient: String? = nil
    
    var title: String
    var color: Color
    var isHighlighted: (String) -> Bool
    
    private var content: some View {
        Section(title) {
            
            ForEach(ingridients) { ingridient in
                TextField("Ingridient", text: binding(for: ingridient))
                    .if(isHighlighted(ingridient)) {
                        $0.foregroundColor(color)
                    }
            }
            .onDelete(perform: delete)
            if let _ = ingridient {
                TextField("", text: $ingridient.nilToEmpty, prompt: Text("Ingridient"))
                    .onSubmit(submit)
            }
            
            
            Button("Add", action: { addIngridient() })
            Button("Shampoo avoid", action: { ingridients = Ingridients.db[.Shampoo]?.reduce([], { $0.appending($1.array) }) ?? [] })
        }
    }
    
    var body: some View {
        if OS.isMacOS {
            VStack(alignment: .leading) {
                content
            }
        } else {
            content
        }
        
    }
    
    private func submit() {
        
        
        if let ingridient = ingridient,
           ingridient.count > 0,
           !ingridients.contains(ingridient)
        {
            let ingridientsNew = ingridient.parsedIngridients.filter { !ingridients.contains($0) }
            ingridients.append(contentsOf: ingridientsNew)
        }
        ingridient = nil
    }
    
    private func addIngridient() {
        guard ingridients.allSatisfy({ !$0.isEmpty }) else { return }
        ingridient = ""
    }
    
    private func delete(at offsets: IndexSet) {
        ingridients.remove(atOffsets: offsets)
    }
    
    private func binding(for string: String) -> Binding<String> {
        guard let index = ingridients.firstIndex(of: string) else {
            fatalError("Could not find string in array")
        }
        return Binding(
            get: { self.ingridients[index] },
            set: { self.ingridients[index] = $0 }
        )
    }
}

struct HighlitedAddableListSection_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            HighlightedAddableListSection(title: "Look for", color: .red, isHighlighted: { non in return true})
        }
    }
}
