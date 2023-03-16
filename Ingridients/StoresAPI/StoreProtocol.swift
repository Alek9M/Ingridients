//
//  Store.swift
//  Ingridients
//
//  Created by M on 12/03/2023.
//

import Foundation
import Combine

protocol StoreProtocol: ObservableObject {
    static var base: URL { get }
    
    static func url(forProducts: Products) -> URL?
    
    func load(_ products: Products)
}

class Store: ObservableObject {
    var products: [Product] = []
    
    @Published internal var productsToLoad = 0
    @Published internal var productsLoaded = 0
    
    internal var loaded: [URL] = []
}

class SuperStore: ObservableObject {
    let stores: [any Store & StoreProtocol] = [Sainsburys()]
    private var cancellables: [AnyCancellable] = []
    
    var products: [Product] {
        stores.flatMap(\.products)
    }
    func load(_ products: Products) {
        stores.forEach { $0.load(products) }
    }
    
    var productsToLoad: Int {
        stores.reduce(0, { $0 + $1.productsToLoad })
    }
    var productsLoaded: Int {
        stores.reduce(0, { $0 + $1.productsLoaded })
    }
    var progress: Float {
        Float(productsLoaded) / Float(productsToLoad)
    }
    
    init() {
        stores.forEach {
            cancellables.append(
                $0.objectWillChange.sink { [weak self] _ in
                    self?.objectWillChange.send()
                }
            )
        }
    }
}

enum Products {
    case Shampoo
    case Toothpaste
}

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

class Product: Identifiable {
    
    struct Info {
        var unit: Unit?
        var amount: Double?
        var quantity: Double?
    }
    
    private(set) var ingridients: Ingridients
    private(set) var title: String
    private(set) var price: Double
    private(set) var url: URL
    private(set) var info = Info()
    
    static private let regexTimes = " ?[xX] ?"
    static private let regexQuantity = "(((\\d+\\.\\d+)|(\\d+))\(regexTimes))"
    static private let regexAmount = "((\\d+\\.\\d+)|(\\d+))"
    
    static private var regex: String {
        //    static private var regex: NSRegularExpression {
        //        try! NSRegularExpression(pattern: #"((\d+\.\d+)|(\d+))( ?[xX] ?((\d+\.\d+)|(\d+)))? ?"# + Unit.regex)
        return " ?\(regexQuantity)?\(regexAmount) ?\(Unit.regex)"
    }
    
    init?(ingridients: Ingridients, title: String, price: String, url: URL) {
        guard let price = Double(price.trimmingPrefix("£")) else { return nil }
        self.ingridients = ingridients
        self.title = title
        self.price = price
        self.url = url
        
        if let range = Product.regex.rangeOfFirstMatch(in: title.lowercased()) {
            var matchedString = String(title[range]).lowercased()
            self.title.replaceSubrange(range, with: "")
            
            
            if let multipleRange = Product.regexQuantity.rangeOfFirstMatch(in: matchedString) {
                var multiple = String(matchedString[multipleRange])
                matchedString.replaceSubrange(multipleRange, with: "")
                let number = multiple.removingMatches(for: Product.regexTimes)
                self.info.quantity = Double(number)
            }
            
            if let unitRange = Unit.regex.rangeOfFirstMatch(in: matchedString) {
                self.info.unit = Unit.decode( String(matchedString[unitRange]))
                matchedString.replaceSubrange(unitRange, with: "")
            }
            
            self.info.amount = Double(matchedString.trimmingCharacters(in: .whitespaces))
        }
        
    }
}
