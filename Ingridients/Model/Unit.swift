//
//  Unit.swift
//  Ingridients
//
//  Created by M on 16/03/2023.
//

import Foundation

enum Unit: CaseIterable {
    case mL, L
    case g, kg
    
    static var regex: String {
        let orSymbol = "|"
        
        var regex = "("
        
        for unit in allCases {
            for symbol in unit.symbols.sorted(by: { $0.count > $1.count }) {
                regex += "\(symbol)\(orSymbol)"
            }
        }
        
        if regex.last == orSymbol.first {
            regex.removeLast()
        }
        
        return regex.lowercased() + ")"
    }
    
    enum Measuring {
        case Weight
        case Volume
    }
    
    var symbols: [String] {
        switch self {
        case .mL:
            return ["mL"]
        case .L:
            return ["L", "Ltr", "Litre"]
        case .g:
            return ["g"]
        case .kg:
            return ["kg"]
        }
    }
    
    var measuring: Measuring {
        switch self {
        case .mL:
            return .Volume
        case .L:
            return .Volume
        case .g:
            return .Weight
        case .kg:
            return .Weight
        }
    }
    
    static func decode(_ symbol: String) -> Unit? {
        for unit in Unit.allCases {
            if unit.symbols.map { $0.lowercased() }.contains(symbol.lowercased()) {
                return unit
            }
        }
        return nil
    }
    
    func convert(_ amount: Double, from: Unit, to: Unit) -> Double {
        guard from != to else { return amount }
        guard from.measuring == to.measuring else { return -1.0 }
        switch from {
        case .kg:
            return amount * 1000.0
        case .g:
            return amount / 1000.0
        case .L:
            return amount * 1000.0
        case .mL:
            return amount / 1000.0
        }
    }
}
