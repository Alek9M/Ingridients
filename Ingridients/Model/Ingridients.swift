//
//  IngridientsLists.swift
//  Ingridients
//
//  Created by M on 02/03/2023.
//

import Foundation

struct Ingridient {
    
    enum Category {
        case Good
        case Bad
    }
    
    enum Found {
        case Whole
        case Prefix
        case Postfix
    }
    
    enum Effects {
        case Health
        case Environment
        case Unknown
    }
    
    let title: String
    let alsoKnownAs: [String]
    let description: String
    let found: Found
    let effect: Effects
    let category: Category
    
    var array: [String] {
        var all = alsoKnownAs
        all.append(title)
        return all
    }
    
    init(title: String, alsoKnownAs: [String] = [], description: String = "", found: Found = .Whole, effect: Effects = .Unknown, category: Category = .Bad) {
        self.title = title
        self.alsoKnownAs = alsoKnownAs
        self.description = description
        self.found = found
        self.effect = effect
        self.category = category
    }
    
    func equals(_ ingridient: String) -> Bool {
        title.contains(ingridient) || alsoKnownAs.contains(where: { $0.contains(ingridient) })
    }
    
}

class Ingridients {
    
    static let db = [
        Products.Shampoo : """
            Ammonium Lauryl Sulfate
            Sodium Laureth Sulfate
            SLES
            Sodium Lauryl Sulfate
            SLS
            Paraben
            Sodium Chloride
            Polyethylene Glycols
            PEG
            Diethanolamine
            DEA
            Triethanolamine
            TEA
            Formaldehyde
            Alcohol
            Dimethicone
            Cocamidopropyl Betaine
            Triclosan
            Retinyl Palmitate
            Formaldehyde
            Dimethicone
            Toluene
            Imidazolidinyl
            """.components(separatedBy: .newlines).map { Ingridient(title: $0) }
    ]
    
    let raw: String
    let array: [String]
    
    func check(_ product: Products, for category: Ingridient.Category) -> [String] {
        return array.filter { ingridient in
            Ingridients.db[product]?.filter({ $0.category == category })
                .contains(where: { $0.equals(ingridient) }) ?? false
        }
    }
    
    init(raw: String) {
        self.raw = String(raw.lowercased().trimmingPrefix("Ingridients:".lowercased()))
        array = raw.parsedIngridients
    }
}
