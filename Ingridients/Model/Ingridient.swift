//
//  Ingridient.swift
//  Ingridients
//
//  Created by M on 11/03/2024.
//

import Foundation
import SwiftData

@Model
class Ingridient {
    
//    enum Category: Codable {
//        case Good
//        case Bad
//        case Unknown
//    }
//    
//    enum Found: Codable {
//        case Whole
//        case Prefix
//        case Postfix
//        case Unknown
//    }
//    
//    enum Effects: Codable {
//        case Health
//        case Environment
//        case Unknown
//    }
    
    let title: String
//    let alsoKnownAs: [String]
    let about: String
//    let found: Found
//    let effect: Effects
//    let category: Category
    
//    var array: [String] {
//        var all = alsoKnownAs
//        all.append(title)
//        return all
//    }
    
    init(title: String, alsoKnownAs: [String] = [], description: String = "") {
        self.title = title
//        self.alsoKnownAs = alsoKnownAs
        self.about = description
//        self.found = found
//        self.effect = effect
//        self.category = category
    }
    
//    func equals(_ ingridient: String) -> Bool {
//        title.contains(ingridient) || alsoKnownAs.contains(where: { $0.contains(ingridient) })
//    }
    
}
