//
//  IngridientsLists.swift
//  Ingridients
//
//  Created by M on 02/03/2023.
//

import Foundation

protocol ProductInfo {
    static var avoid: [String] { get }
    static var lookFor: [String] { get }
    
}

class Ingridients {
    class Shampoo: ProductInfo {
        static private let avoidRaw = """
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
"""
        static var avoid: [String] {
            avoidRaw.parsedIngridients
        }
        
        static var lookFor: [String] {
            []
        }
        
        static func check(_ product: Product) -> [String] {
            return avoid.filter { product.ingridients.array.contains($0) }
        }
    }
    
    let raw: String
    let array: [String]
    
    init(raw: String) {
        self.raw = String(raw.trimmingPrefix("Ingridients: "))
        array = raw.parsedIngridients
    }
}
