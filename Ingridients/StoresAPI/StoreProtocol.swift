//
//  Store.swift
//  Ingridients
//
//  Created by M on 12/03/2023.
//

import Foundation

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
