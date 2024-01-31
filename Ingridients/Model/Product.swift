//
//  Product.swift
//  Ingridients
//
//  Created by M on 16/03/2023.
//

import Foundation

enum Products: String, CaseIterable, Identifiable {
    case Shampoo = "Shampoo"
    case Toothpaste = "Toothpaste"
    
    static var allCases = [Products.Shampoo, .Toothpaste]
    
    var id: String {
        rawValue
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
