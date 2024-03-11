//
//  IngridientsLists.swift
//  Ingridients
//
//  Created by M on 02/03/2023.
//

import Foundation
import SwiftData

@Model
class Ingridients {
    
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
    
    private var _raw: String
    
    @Transient
    private var works: [DispatchWorkItem] = []
    private static let queue = DispatchQueue.global(qos: .utility)
    
    var raw: String {
        set {
            _raw = newValue
            works.forEach({$0.cancel()})
            
            
            let work = DispatchWorkItem {
                Task {
                    guard let result = try? await AI.shared?.parseIngridients(self._raw) else { return }
                    
                    DispatchQueue.main.sync {
                        self.ai = result
                    }
                }
            }
            Ingridients.queue.asyncAfter(deadline: .now() + 2, execute: work)
            
            
            works = works.filter({!$0.isCancelled})
            works.append(work)
        }
        get {
            _raw
        }
    }
    var array: [String] {
        ai.count > 0 ?
        ai.map(\.title)  :
        Ingridients.rawProcessing(raw)
            .lowercased()
            .components(separatedBy: ",")
            .compactMap { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .map { $0.presentable }
    }
    
    @Transient
    var ai: [Ingridient] = []
    
    func check(_ product: Products) -> [String] {
        return array
        //            .filter { ingridient in
        //            Ingridients.db[product]?.filter({ $0.category == category })
        //                .contains(where: { $0.equals(ingridient) }) ?? false
        //        }
    }
    
    init(raw: String) {
        self._raw = raw// Ingridients.rawProcessing(raw)
    }
    
    func intersect(with string: Ingridients) -> [Ingridient] {
        return array.filter { string.array.contains($0) }.map({ Ingridient(title: $0) })
    }
    
    func notFound(within string: Ingridients) -> [Ingridient] {
        let elements = string.array
        return array.filter { !elements.contains($0) }.map({ Ingridient(title: $0) })
    }
    
    private static func rawProcessing(_ raw: String) -> String {
        return String(raw.lowercased().trimmingPrefix("ingredients:"))
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
