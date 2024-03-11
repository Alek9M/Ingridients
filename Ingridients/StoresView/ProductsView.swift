//
//  TescoShampooView.swift
//  Ingridients
//
//  Created by M on 02/03/2023.
//

import SwiftUI

struct ProductsView: View {
    
    @ObservedObject var store = SuperStore()
    @State var product = Products.Toothpaste
    
    var body: some View {
        
        ScrollView {
            ProgressView(value: store.progress)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 200))], spacing: 40) {
//                ForEach(store.products.sorted(by: lessAvoid)) { product in
//                    ProductCard(product: product)
//                }
            }
        }
        .onAppear {
            store.load(.Shampoo)
        }
        .toolbar {
            ToolbarItem(placement: .status) {
                Menu("Product") {
                    ForEach(Products.allCases) { pro in
                        Button(pro.rawValue, action: { product = pro })
                    }
                }
            }
        }
    }
    
//    func lessAvoid(_ a: Product, _ b: Product) -> Bool {
//        return a.ingridients.check(.Shampoo, for: .Bad).count < b.ingridients.check(.Shampoo, for: .Bad).count
//    }
}

struct ProductsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsView()
    }
}
