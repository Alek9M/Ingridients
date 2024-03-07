//
//  Comparator.swift
//  Ingridients
//
//  Created by M on 27/02/2023.
//

import SwiftUI

struct ComparatorView: View {
    
    @State private var ingridientsAraw = "INGREDIENTS:Basil (48%), Sunflower Oil, Grana Padano Cheese (Cows' Milk,  Contains Preservative: Egg Lysozyme)(5%), Cashew Nuts (5%), Glucose, Potato Flakes, Vegetable Fibre, Salt, Acidity Regulator: Lactic Acid; Pecorino Romano Cheese (Sheep's Milk) (0.5%), Extra Virgin Olive Oil, Pine Nuts (0.5%), Garlic Powder, Antioxidant: Ascorbic Acid."
    @State private var ingridientsBraw = "INGREDIENTS: Basil (47%), Sunflower Oil, Grana Padano Cheese (5%) [Grana Padano Cheese (Milk), Preservative (Egg Lysozyme)], Yogurt (Milk), Cashew Nut (5%), Extra Virgin Olive Oil, Sugar, Pecorino Romano Cheese (Milk), Pea Fibre, Salt, Pine Nuts (1%), Acidity Regulator (Lactic Acid), Garlic Powder."
    
    private var same: [String] {
        ingridientsAraw.intersect(with: ingridientsBraw)
    }
    
    private var uniqueToA: [String] {
        ingridientsBraw.isEmpty ? [] : ingridientsAraw.notFound(within: ingridientsBraw)
    }
    
    private var uniqueToB: [String] {
        ingridientsAraw.isEmpty ? [] : ingridientsBraw.notFound(within: ingridientsAraw)
    }
    
    private func section(title: String, ingridients: [String]) -> some View {
        return Section(title) {
            ForEach(ingridients) { ingridient in
                Text(ingridient.presentable)
            }
            .if(OS.isMacOS) {
                $0
                    .padding(.horizontal)
            }
        }
    }
    
    private var mobile: some View {
        Group {
            
            IngridientsSection(title: "A", ingridientsRaw: $ingridientsAraw)
            IngridientsSection(title: "B", ingridientsRaw: $ingridientsBraw)
            
            if same.count > 0 {
                section(title: "same", ingridients: same)
            }
            
            if uniqueToA.count > 0 {
                section(title: "different in a", ingridients: uniqueToA)
            }
            
            if uniqueToB.count > 0 {
                section(title: "different in b", ingridients: uniqueToB)
            }
        }
    }
    
    private var computer: some View {
        ScrollView {
            VStack {
                HStack {
                    IngridientsSection(title: "A", ingridientsRaw: $ingridientsAraw)
                    
                    VStack(alignment: .leading) {
                        section(title: "same", ingridients: same)
                            .orSpacer(same.count > 0)
                            .fixedSize()
                    }
                    
                    IngridientsSection(title: "B", ingridientsRaw: $ingridientsBraw)
                }
                HStack {
                    VStack(alignment: .leading) {
                        section(title: "different in a", ingridients: uniqueToA)
                            .orSpacer(uniqueToA.count > 0)
                            .fixedSize()
                    }
                    VStack(alignment: .leading) {
                        section(title: "different in b", ingridients: uniqueToB)
                            .orSpacer(uniqueToB.count > 0)
                            .fixedSize()
                    }
                }
            }
        }
    }
    
    var body: some View {
        Group {
            if OS.isMacOS {
                computer
            } else {
                Form {
                    mobile
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
