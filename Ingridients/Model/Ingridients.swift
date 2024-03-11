//
//  IngridientsLists.swift
//  Ingridients
//
//  Created by M on 02/03/2023.
//

import Foundation
import SwiftData

@Model
class Ingridient {
    
    enum Category: Codable {
        case Good
        case Bad
        case Unknown
    }
    
    enum Found: Codable {
        case Whole
        case Prefix
        case Postfix
        case Unknown
    }
    
    enum Effects: Codable {
        case Health
        case Environment
        case Unknown
    }
    
    let title: String
    let alsoKnownAs: [String]
    let about: String
    let found: Found
    let effect: Effects
    let category: Category
    
    var array: [String] {
        var all = alsoKnownAs
        all.append(title)
        return all
    }
    
    init(title: String, alsoKnownAs: [String] = [], description: String = "", found: Found = .Unknown, effect: Effects = .Unknown, category: Category = .Unknown) {
        self.title = title
        self.alsoKnownAs = alsoKnownAs
        self.about = description
        self.found = found
        self.effect = effect
        self.category = category
    }
    
    func equals(_ ingridient: String) -> Bool {
        title.contains(ingridient) || alsoKnownAs.contains(where: { $0.contains(ingridient) })
    }
    
}

@Model
class Ingridients: ObservableObject {
    
//    static let db = [
//        Products.Shampoo : """
//            Ammonium Lauryl Sulfate
//            Sodium Laureth Sulfate
//            SLES
//            Sodium Lauryl Sulfate
//            SLS
//            Paraben
//            Sodium Chloride
//            Polyethylene Glycols
//            PEG
//            Diethanolamine
//            DEA
//            Triethanolamine
//            TEA
//            Formaldehyde
//            Alcohol
//            Dimethicone
//            Cocamidopropyl Betaine
//            Triclosan
//            Retinyl Palmitate
//            Formaldehyde
//            Dimethicone
//            Toluene
//            Imidazolidinyl
//            """.components(separatedBy: .newlines).map { Ingridient(title: $0) }
//    ]
    
    var raw: String
    var array: [String] {
        raw
            .lowercased()
            .components(separatedBy: ",")
            .filter { !$0.isEmpty }
            .map { $0.presentable }
    }
    var aiRaw: String? = nil
    
    func check(_ product: Products, for category: Ingridient.Category) -> [String] {
        return array
//            .filter { ingridient in
//            Ingridients.db[product]?.filter({ $0.category == category })
//                .contains(where: { $0.equals(ingridient) }) ?? false
//        }
    }
    
    init(raw: String) {
        self.raw = raw// Ingridients.rawProcessing(raw)
    }
    
    func intersect(with string: Ingridients) -> [Ingridient] {
        let elements = string.array
        return array.filter { elements.contains($0) }.map({ Ingridient(title: $0) })
    }
    
    func notFound(within string: Ingridients) -> [Ingridient] {
        let elements = string.array
        return array.filter { !elements.contains($0) }.map({ Ingridient(title: $0) })
    }
    
//    private static func rawProcessing(_ raw: String) -> String {
//        String(raw.lowercased().trimmingPrefix("ingridients:"))
//    }
    
    func same(as raw: String) -> Bool {
        self.raw == raw // Ingridients.rawProcessing(raw)
    }
    
    func contains(_ ingridient: String) -> Bool {
        return array.contains { $0.lowercased() == ingridient.lowercased() }
    }
    
    func similar(_ ingridient: String) -> Bool {
        return array.contains { raw in
            let rawLow = raw.lowercased()
            let ingLow = ingridient.lowercased()
            return rawLow.hasPrefix(ingLow) || rawLow.hasSuffix(ingLow) }
    }
}
