//
//  SuperStore.swift
//  Ingridients
//
//  Created by M on 16/03/2023.
//

import Foundation
import Combine

class SuperStore: ObservableObject {
    let stores: [any Store & StoreProtocol] = [Tesco()]
    private var cancellables: [AnyCancellable] = []
    
//    var products: [Products : [Product]] {
//        stores.reduce([:], { result, store in
//            var res = result
//            for product in store.products {
//                res[product.key]?.append(contentsOf: product.value)
//            }
//            return res
//        })
//    }
    
    var products: [Product] {
        stores.reduce([], { result, store in
                    var res = result
                    for product in store.products {
                        res.append(product)
                    }
                    return res
                })
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
