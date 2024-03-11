//
//  IngridientsSection.swift
//  Ingridients
//
//  Created by M on 26/02/2023.
//

import SwiftUI

struct IngridientsSection: View {
    
    private static let queue = DispatchQueue.global(qos: .utility)
    
    let title: LocalizedStringKey
    
    @Binding var ingridients: Ingridients
    
    @State private var detailed = false
    
    private var content: some View {
        Group {
            TextEditor(text: $ingridients.raw)
//                .onChange(of: ingridients.raw) { newRaw in
////                    works.forEach({$0.cancel()})
////                    if (aiRaw != ingridientsRaw) {
////                        let work = DispatchWorkItem {
////                            Task {
////                                let result = try? await ai?.parseIngridients(ingridientsRaw)
//////                                if let aiRaw = result?.map(\.ingredient).reduce("", {$0 + "," + $1}), !aiRaw.isEmpty {
//////                                    DispatchQueue.main.async {
//////                                        ingridientsRaw = aiRaw
//////                                        self.aiRaw = aiRaw
//////                                        self.aiResult = result
//////                                    }
//////                                }
////                            }
////                        }
////                        IngridientsSection.queue.asyncAfter(deadline: .now() + 2, execute: work)
////                    }
////                    works = works.filter({!$0.isCancelled})
//                }
            
            if detailed {
                ForEach(ingridients.array) { ingridient in
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
            if !OS.isMacOS {
                Button(action: { withAnimation { detailed.toggle() } }) {
                    Label(detailed ? "hide" : "show", systemImage: detailed ? "chevron.down" : "chevron.right")
                        .labelStyle(.iconOnly)
                }
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

//struct IngridientsSection_Previews: PreviewProvider {
//    static var previews: some View {
//        Form {
//            IngridientsSection(title: "A", ingridients: Ingridients(raw: "wheat, rye, water"))
//        }
//    }
//}
