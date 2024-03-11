//
//  IngridientsLists.swift
//  Ingridients
//
//  Created by M on 02/03/2023.
//

import Foundation
import SwiftData


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
        Ingridients.rawProcessing(raw)
            .lowercased()
            .components(separatedBy: ",")
            .compactMap { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .map { $0.presentable }
    }
    var aiRaw: String? = nil
    
    func check(_ product: Products) -> [String] {
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
    
    private static func rawProcessing(_ raw: String) -> String {
        String(raw.lowercased().trimmingPrefix("ingridients:"))
    }
    
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
