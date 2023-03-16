//
//  File.swift
//  Ingridients
//
//  Created by M on 02/03/2023.
//

import Foundation

class OS {
    enum Platform {
        case macOS
        case iOS
        case watchOS
        case tvOS
    }
    
    static var platform: Platform {
#if os(iOS)
        return Platform.iOS
#elseif os(macOS)
        return Platform.macOS
#else
        fatalError()
#endif
    }
    
    static var isIOS: Bool {
        return platform == Platform.iOS
    }
    
    static var isMacOS: Bool {
        return platform == Platform.macOS
    }
}
