//
//  OpenAI.swift
//  Ingridients
//
//  Created by M on 07/03/2024.
//

import Foundation
import OpenAI

class AI {
    
    static private(set) var shared = try? AI()
    
    private struct AIResult: Codable {
        let ingredients: [AIIngridient]
    }
    
    private struct AIIngridient: Codable {
        let ingredient: String
        let percentage: Double?
        let category: String?
        let subingredients: [AIIngridient]?
        
        func objectified() -> Ingridient {
            Ingridient(title: ingredient, percentage: percentage, category: category, subingredients: subingredients?.compactMap{ $0.objectified() })
        }
    }
    
    enum AIError: Error {
        case json
    }
    
    private static var prompt = """
You are an ingridients parser. The text is scaned from picture so some letters might not be recognised correctly or at all, fix those. Ignore parts that got scanned along but clearly don't belong in an ingridients list. Return a json such so that given a string
*INGREDIENTS: Basil (47%), Sunflower Oil, Grana Padano Cheese (5%) [Grana Padano Cheese (Milk), Preservative (Egg Lysozyme)], Yogurt (Milk), Cashew Nut (5%), Extra Virgin Olive Oil, Sugar, Pecorino Romano Cheese (Milk), Acidity Regulator (Lactic Acid), Antioxidant: Ascorbic Acid.*
 you return
[
 {
 "ingridient": "Basil",
 "percentage": 47,
 "category": "Herb",
 "origin": "Basil (47%)"
 },
 {
 "ingridient": "Sunflower Oil",
 "category": "Oil",
 "origin": "Sunflower Oil"
 },
 {
 "ingridient": "Grana Padano",
 "percentage": 5,
 "category": "Cheese",
 "subingridients": [
 {
 "ingridient": "Grana Padano",
 "category": "Milk"
 },
 {
 "ingridient": "Egg Lysozyme",
 "category": "Preservative"
 }
 ],
 origin: "Grana Padano Cheese (5%) [Grana Padano Cheese (Milk), Preservative (Egg Lysozyme)]"
 },
 {
 "ingridient": "Yogurt",
 "category": "Milk"
 },
 {
 "ingridient": "Cashew",
 "percentage": 5,
 "category": "Nut"
 },
 {
 "ingridient": "Extra Virgin Olive Oil, Sugar, Pecorino Romano Cheese (Milk)",
 "category": "Oil"
 },
 {
 "ingridient": "Sugar"
 },
 {
 "ingridient": "Pecorino Romano",
 "category": "Cheese"
 },
 {
 "ingridient": "Lactic Acid",
 "category": "Acidity Regulator"
 },
 {
 "ingridient": "Ascorbic Acid",
 "category": "Antioxidant"
 }
 ]
Always include ALL of the ingridients. Do NOT include "nut" or "chese" to ingridients that have a name (named cheese or nut) but do include them if it generically just says "cheese" or "nuts". So if it says Cashew Nut -> just name it Cashew as it is abvious that it is a nut.
"""
    
    private var api: String
        var openAI: OpenAI
    
    init() throws {
        api = CloudDefaults.api.rawValue.fromCloud
        guard api != "" else { throw URLError(.fileDoesNotExist) }
        openAI = OpenAI(apiToken: api)
        
    }
    
        func parseIngridients(_ raw: String) async throws -> [Ingridient] {
            let query = ChatQuery(
                model: .gpt3_5Turbo,
                messages: [.init(role: .system, content: AI.prompt), .init(role: .user, content: raw)],
                responseFormat: .jsonObject,
                temperature: 0.2
            )
            guard var result = (try await openAI.chats(query: query)).choices.first?.message.content else { throw AIError.json }
    
            guard let data = result.data(using: .utf8),
               let ingredients = try? JSONDecoder().decode(AIResult.self, from: data) else {
                   throw AIError.json
            }
            
//            let ingredients = try decoder.decode([Ingridient].self, from: data)
    
            return ingredients.ingredients.compactMap{ $0.objectified() }
        }
    
    
}
