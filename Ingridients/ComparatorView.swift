//
//  Comparator.swift
//  Ingridients
//
//  Created by M on 27/02/2023.
//

import SwiftUI

struct ComparatorView: View {
    
    @State private var ingridientsAraw = ""// "INGREDIENTS:Basil (48%), Sunflower Oil, Grana Padano Cheese (Cows' Milk,  Contains Preservative: Egg Lysozyme)(5%), Cashew Nuts (5%), Glucose, Potato Flakes, Vegetable Fibre, Salt, Acidity Regulator: Lactic Acid; Pecorino Romano Cheese (Sheep's Milk) (0.5%), Extra Virgin Olive Oil, Pine Nuts (0.5%), Garlic Powder, Antioxidant: Ascorbic Acid."
    @State private var ingridientsBraw = ""// "INGREDIENTS: Basil (47%), Sunflower Oil, Grana Padano Cheese (5%) [Grana Padano Cheese (Milk), Preservative (Egg Lysozyme)], Yogurt (Milk), Cashew Nut (5%), Extra Virgin Olive Oil, Sugar, Pecorino Romano Cheese (Milk), Pea Fibre, Salt, Pine Nuts (1%), Acidity Regulator (Lactic Acid), Garlic Powder."
    
    @State private var settings = false
    
    private var same: [String] {
        ingridientsAraw.intersect(with: ingridientsBraw)
    }
    
    private var uniqueToA: [String] {
        ingridientsBraw.isEmpty ? [] : ingridientsAraw.notFound(within: ingridientsBraw)
    }
    
    private var uniqueToB: [String] {
        ingridientsAraw.isEmpty ? [] : ingridientsBraw.notFound(within: ingridientsAraw)
    }
    
    private func section(title: LocalizedStringKey, ingridients: [String]) -> some View {
        return Section(title) {
            ForEach(ingridients) { ingridient in
                Text(ingridient.presentable)
            }
            .if(OS.isMacOS) {
                $0
                    .padding(.horizontal)
                    .padding(.vertical, 0.5)
            }
        }
    }
    
    enum SectionName: LocalizedStringKey {
    case same = "Same"
    case aDif = "Different in a"
    case bDif = "Different in b"
    case a = "A"
    case b = "B"
    }
    
    private var mobile: some View {
        Group {
            
            IngridientsSection(title: SectionName.a.rawValue, ingridientsRaw: $ingridientsAraw)
            IngridientsSection(title: SectionName.b.rawValue, ingridientsRaw: $ingridientsBraw)
            
            if same.count > 0 {
                section(title: SectionName.same.rawValue, ingridients: same)
            }
            
            if uniqueToA.count > 0 {
                section(title: SectionName.aDif.rawValue, ingridients: uniqueToA)
            }
            
            if uniqueToB.count > 0 {
                section(title: SectionName.bDif.rawValue, ingridients: uniqueToB)
            }
        }
    }
    
    private var computer: some View {
        ScrollView {
            VStack {
                HStack {
                    IngridientsSection(title: SectionName.a.rawValue, ingridientsRaw: $ingridientsAraw)
                    
                    VStack(alignment: .leading) {
                        section(title: SectionName.same.rawValue, ingridients: same)
                            .orSpacer(same.count > 0)
                            .fixedSize()
                    }
                    
                    IngridientsSection(title: SectionName.b.rawValue, ingridientsRaw: $ingridientsBraw)
                }
                HStack {
                    VStack(alignment: .leading) {
                        section(title: SectionName.aDif.rawValue, ingridients: uniqueToA)
                            .orSpacer(uniqueToA.count > 0)
                            .fixedSize()
                    }
                    VStack(alignment: .leading) {
                        section(title: SectionName.bDif.rawValue, ingridients: uniqueToB)
                            .orSpacer(uniqueToB.count > 0)
                            .fixedSize()
                    }
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if OS.isMacOS {
                    computer
                } else {
                    Form {
                        mobile
                    }
                    .navigationTitle("Comparator")
                    .settings(areShown: $settings)
                }
            }
        }
    }
}

struct Comparator_Previews: PreviewProvider {
    static var previews: some View {
        ComparatorView()
    }
}
