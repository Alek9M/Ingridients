//
//  Tesco.swift
//  Ingridients
//
//  Created by M on 02/03/2023.
//

import Foundation
import SwiftSoup

class Tesco: Store, StoreProtocol {
    static internal let base = URL(string: "https://www.tesco.com")!
    static private let shampoos = base.appending(path:"/groceries/en-GB/shop/health-and-beauty/shampoo/all")
    static private let toothpaste = base.appending(path:"/groceries/en-GB/shop/health-and-beauty/toothpaste-mouthwash-and-toothbrush/toothpaste/all")
    
    static private let pagesButtonsClass = "pagination--page-selector-wrapper"
    static private let gridClass = "product-list grid"
    
    //    @Published var productsToLoad = 0
    //    @Published var productsLoaded = 0
    var progress: Float {
        Float(productsLoaded) / Float(productsToLoad)
    }
    
    //    @Published private(set) var products: [Product] = []
    //
    //    private var loaded: [URL] = []
    //
    //    init() {
    //
    //    }
    
    static internal func url(forProducts: Products) -> URL? {
        switch forProducts {
        case .Shampoo:
            return shampoos
        default:
            return nil
        }
    }
    
    func load(_ products: Products) {
        guard let url = Tesco.url(forProducts: products) else { return }
        DispatchQueue.global().async {
            self.load(page: url)
        }
    }
    
    private func load(page: URL) {
        
        DispatchQueue.main.async {
            guard !self.loaded.contains(page) else { return }
            self.loaded.append(page)
            print(page.absoluteString)
            
            DispatchQueue.global(qos: .userInitiated).async {
                guard let html = try? String(contentsOf: page),
                      let soup = try? SwiftSoup.parse(html, Tesco.shampoos.absoluteString),
                      let pageButtonsRaw = try? soup.getElementsByClass(Tesco.pagesButtonsClass).first(),
                      let grid = try? soup.getElementsByClass(Tesco.gridClass).first(),
                      let products = try? grid.getElementsByTag("li"),
                      let pageButtons = try? pageButtonsRaw.getElementsByTag("li") else { return }
                
                DispatchQueue.main.async {
                    self.productsToLoad += products.count
                }
                
                for url in self.extractPagesURLs(from: pageButtons) {
                    if !self.loaded.contains(url) {
//                        self.load(page: url)
                    }
                }
                
                for product in products {
                    //                    DispatchQueue.global().async {
                    self.addProduct(product)
                    //                    }
                }
            }
        }
        
        
    }
    
    private func extractPagesURLs(from pageButtons: Elements) -> [URL] {
        return pageButtons.compactMap { li in
            guard let a = try? li.getElementsByTag("a"),
                  let href = try? a.attr("href"),
                  href.count > 0 else { return nil }
            let incorrect = href.replacingOccurrences(of: "%3F", with: "?")
            let inc = Tesco.base.appending(path: incorrect)
            let correct = inc.absoluteString.replacingOccurrences(of: "%3F", with: "?")
            return URL(string: correct)
        }
    }
    
    private func addProduct(_ product: Element) {
        guard let a = try? product.getElementsByTag("a").first(),
              let url = try? a.attr("href"),
              let productHTML = try? String(contentsOf: Tesco.base.appending(path: url)),
              let productSoup = try? SwiftSoup.parse(productHTML, Tesco.base.appending(path: url).absoluteString),
              let ingridientsElement = try? productSoup.getElementById("ingredients"),
              let ingridientsElementDeep = try? ingridientsElement.getElementsByClass("product-info-block__content").first(),
              let ingridientsText = try? ingridientsElementDeep.text(),
              let h3 = try? product.getElementsByTag("h3").first(),
              let title = try? h3.text(),
              let ps = try? product.getElementsByTag("p"),
              let price = try? ps.first()?.text(),
              let value = try? ps[1].text()  else { return } // price per
        
        if let product = Product(ingridients: Ingridients(raw: ingridientsText), title: title, price: price, url: Tesco.base.appending(path: url)) {
            DispatchQueue.main.async {
                self.products.append(product)
                self.productsLoaded += 1
                self.objectWillChange.send()
            }
        }
    }
}


