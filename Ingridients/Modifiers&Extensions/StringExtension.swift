//
//  StringExtension.swift
//  Ingridients
//
//  Created by M on 26/02/2023.
//

import Foundation
import SwiftUI
import AQUI

extension String: Identifiable {
    public var id: Int {
        self.hashValue
    }
}

extension String {
    
    public var fromCloud: String {
        NSUbiquitousKeyValueStore.default.string(forKey: self) ?? ""
    }
    
    public var parsedIngridients: [String] {
//        let separators: CharacterSet = .newlines.union(.punctuationCharacters)
        return self
//            .components(separatedBy: separators)
//            .fil
            .lowercased()
//            .trimmingPrefix("INGREDIENTS:".lowercased())
            .components(separatedBy: ",")
            .filter { !$0.isEmpty }
            .map { $0.presentable }
    }
    
    public var presentable: String {
        if allSatisfy({ $0.isUppercase || $0.isNumber || $0.isSymbol }) {
            return trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            return capitalized.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    public func intersect(with string: String) -> [String] {
        let elements = string.parsedIngridients
        return parsedIngridients.filter { elements.contains($0) }
    }
    
    public func notFound(within string: String) -> [String] {
        let elements = string.parsedIngridients
        return parsedIngridients.filter { !elements.contains($0) }
    }
    
    public func rangeOfFirstMatch(in string: String) -> Range<String.Index>? {
        guard let regex = try? NSRegularExpression(pattern: self) else { return nil }
        let NS = regex.rangeOfFirstMatch(in: string, range: NSRange(location: 0, length: string.utf16.count))
        return Range(NS, in: string)
    }
    
    mutating func removeMatches(for pattern: String) {
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let range = NSRange(location: 0, length: self.utf16.count)
            let modifiedString = regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
            self = modifiedString
        } catch {
            print("Invalid regex pattern: \(error.localizedDescription)")
        }
    }
    
    func removingMatches(for pattern: String) -> String {
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let range = NSRange(location: 0, length: self.utf16.count)
            let modifiedString = regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
            return modifiedString
        } catch {
            print("Invalid regex pattern: \(error.localizedDescription)")
        }
        return self
    }
}

extension Binding<String?> {
    var nilEqEmpty: Binding<String> {
        Binding<String>(self, replacingNilWith: "")
    }
    
    var nilToEmpty: Binding<String> {
        Binding<String>(self, "")
    }
}

extension Double {
    var asMoney: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var stringValue = formatter.string(from: NSNumber(value: self))!
        
        if let dotIndex = stringValue.firstIndex(of: ".") {
            let endIndex = stringValue.index(after: dotIndex)
            let decimalDigits = stringValue[endIndex...]
            if decimalDigits == "00" {
                stringValue.removeSubrange(dotIndex...)
            }
        }
        
        return stringValue
    }
}

extension [String] {
    func appending(_ string: String) -> [String] {
        var array = self
        array.append(string)
        return array
    }
    
    func appending(_ stringArray: [String]) -> [String] {
        var array = self
        array.append(contentsOf: stringArray)
        return array
    }
}
