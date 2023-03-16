//
//  ProductCard.swift
//  Ingridients
//
//  Created by M on 12/03/2023.
//

import SwiftUI

struct ProductCard: View {
    
    var product: Product
    
    var body: some View {
        Link(destination: product.url) {
            VStack {
                HStack {
                    Text(product.title)
                        .font(.title3)
                    VStack {
                        Text("£\(product.price.asMoney)")
                        if let quantity = product.info.quantity {
                            Text(quantity.asMoney)
                        }
                        HStack {
                            Text("\(product.info.amount?.asMoney ?? "nil")")
                            Text("\(product.info.unit?.symbols.first ?? "nil")")
                        }
                    }
                }
            }
            .padding(10)
            .overlay{
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray, lineWidth: 2)
            }
            .padding(2)
        }
        .foregroundColor(.primary)
    }
}

struct ProductCard_Previews: PreviewProvider {
    static var previews: some View {
        let ing = Ingridients(raw: "water, salt")
        let pro = Product(ingridients: ing, title: "Aussie Miracle Moist Shampoo 300Ml", price: "11", url: URL(string: "apple.com")!)!
        let info = Product.Info(unit: .L, amount: 2.0, quantity: 4)
        ProductCard(product: pro)
    }
}
