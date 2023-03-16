//
//  Comparator.swift
//  Ingridients
//
//  Created by M on 27/02/2023.
//

import SwiftUI

struct ComparatorView: View {
    
    @State private var ingridientsAraw = ""
    @State private var ingridientsBraw = ""
    
    private var same: [String] {
        ingridientsAraw.intersect(with: ingridientsBraw)
    }
    
    private var uniqueToA: [String] {
        ingridientsBraw.isEmpty ? [] : ingridientsAraw.notFound(within: ingridientsBraw)
    }
    
    private var uniqueToB: [String] {
        ingridientsAraw.isEmpty ? [] : ingridientsBraw.notFound(within: ingridientsAraw)
    }
    
    private var content: some View {
        Group {
            
            IngridientsSection(title: "A", ingridientsRaw: $ingridientsAraw)
            IngridientsSection(title: "B", ingridientsRaw: $ingridientsBraw)
            
            if same.count > 0 {
                Section("same") {
                    ForEach(same) { ingridient in
                        Text(ingridient.presentable)
                    }
                }
            }
            
            if uniqueToA.count > 0 {
                Section("different in a") {
                    ForEach(uniqueToA) { ingridient in
                        Text(ingridient.presentable)
                    }
                }
            }
            
            if uniqueToB.count > 0 {
                Section("different in b") {
                    ForEach(uniqueToB) { ingridient in
                        Text(ingridient.presentable)
                    }
                }
            }
            
            
        }
    }
    
    var body: some View {
        Group {
            if OS.isMacOS {
                ScrollView {
                    VStack {
                        HStack {
                            IngridientsSection(title: "A", ingridientsRaw: $ingridientsAraw)
                            
                            VStack {
                                Section("same") {
                                    ForEach(same) { ingridient in
                                        Text(ingridient.presentable)
                                    }
                                }
                                .orSpacer(same.count > 0)
                            .fixedSize()
                            }
                            
                            IngridientsSection(title: "B", ingridientsRaw: $ingridientsBraw)
                        }
                        HStack {
                            VStack {
                                Section("different in a") {
                                    ForEach(uniqueToA) { ingridient in
                                        Text(ingridient.presentable)
                                    }
                                }
                                .orSpacer(uniqueToA.count > 0)
                            .fixedSize()
                            }
                            VStack {
                                Section("different in b") {
                                    ForEach(uniqueToB) { ingridient in
                                        Text(ingridient.presentable)
                                    }
                                }
                                .orSpacer(uniqueToB.count > 0)
                            .fixedSize()
                            }
                        }
                    }
                }
            } else {
                Form {
                    content
                }
            }
        }
        .navigationTitle("Comparator")
    }
}

struct Comparator_Previews: PreviewProvider {
    static var previews: some View {
        ComparatorView()
    }
}
