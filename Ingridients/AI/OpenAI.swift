//
//  OpenAI.swift
//  Ingridients
//
//  Created by M on 07/03/2024.
//

import Foundation
import SwiftOpenAI

class OpenAi {
    
    private var api: String
    var openAI: SwiftOpenAI
    
    init() throws {
        api = CloudDefaults.api.rawValue.fromCloud
        guard api != "" else { throw URLError(.fileDoesNotExist) }
        openAI = SwiftOpenAI(apiKey: api)
    }
    
    
}
