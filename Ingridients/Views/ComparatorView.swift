//
//  Comparator.swift
//  Ingridients
//
//  Created by M on 27/02/2023.
//

import SwiftUI

struct ComparatorView: View {
    
    @State private var ingridientsA = Ingridients(raw: "") // "INGREDIENTS:Basil (48%), Sunflower Oil, Grana Padano Cheese (Cows' Milk,  Contains Preservative: Egg Lysozyme)(5%), Cashew Nuts (5%), Glucose, Potato Flakes, Vegetable Fibre, Salt, Acidity Regulator: Lactic Acid; Pecorino Romano Cheese (Sheep's Milk) (0.5%), Extra Virgin Olive Oil, Pine Nuts (0.5%), Garlic Powder, Antioxidant: Ascorbic Acid."
    @State private var ingridientsB = Ingridients(raw: "") // "INGREDIENTS: Basil (47%), Sunflower Oil, Grana Padano Cheese (5%) [Grana Padano Cheese (Milk), Preservative (Egg Lysozyme)], Yogurt (Milk), Cashew Nut (5%), Extra Virgin Olive Oil, Sugar, Pecorino Romano Cheese (Milk), Pea Fibre, Salt, Pine Nuts (1%), Acidity Regulator (Lactic Acid), Garlic Powder."
    
    @State private var settings = false
    
    private var same: [Ingridient] {
        ingridientsA.intersect(with: ingridientsB)
    }
    
    private var uniqueToA: [Ingridient] {
        ingridientsA.notFound(within: ingridientsB)
    }
    
    private var uniqueToB: [Ingridient] {
        ingridientsB.notFound(within: ingridientsA)
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
            
            IngridientsEditor(title: SectionName.a.rawValue, ingridients: $ingridientsA)
            IngridientsEditor(title: SectionName.b.rawValue, ingridients: $ingridientsB)
            
            if same.count > 0 {
                IngridientsSection(title: SectionName.same.rawValue, ingridients: same)
            }
            
            if uniqueToA.count > 0 {
                IngridientsSection(title: SectionName.aDif.rawValue, ingridients: uniqueToA)
            }
            
            if uniqueToB.count > 0 {
                IngridientsSection(title: SectionName.bDif.rawValue, ingridients: uniqueToB)
            }
        }
    }
    
    private var computer: some View {
        ScrollView {
            VStack {
                HStack {
                    IngridientsEditor(title: SectionName.a.rawValue, ingridients: $ingridientsA)
                    
                    VStack(alignment: .leading) {
                        IngridientsSection(title: SectionName.same.rawValue, ingridients: same)
                            .orSpacer(same.count > 0)
                            .fixedSize()
                    }
                    
                    IngridientsEditor(title: SectionName.b.rawValue, ingridients: $ingridientsB)
                }
                HStack {
                    VStack(alignment: .leading) {
                        IngridientsSection(title: SectionName.aDif.rawValue, ingridients: uniqueToA)
                            .orSpacer(uniqueToA.count > 0)
                            .fixedSize()
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        IngridientsSection(title: SectionName.bDif.rawValue, ingridients: uniqueToB)
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
