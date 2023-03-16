//
//  TescoShampooView.swift
//  Ingridients
//
//  Created by M on 02/03/2023.
//

import SwiftUI

struct TescoShampooView: View {
    
    @ObservedObject var tesco = SuperStore()
    
    var body: some View {
        
        ScrollView {
            ProgressView(value: tesco.progress)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 200))], spacing: 40) {
                ForEach(tesco.products.sorted(by: lessAvoid)) { shampoo in
                    VStack(alignment: .leading) {
                        ProductCard(product: shampoo)
                        HStack {
                            Text(Ingridients.Shampoo.check(shampoo).count.description)
                            Text(Ingridients.Shampoo.check(shampoo).reduce("", { $0.appending("\($1), ") }))
                        }
                    }
                }
                
            }
        }
        .task {
            await tesco.load(.Shampoo)
        }
    }
    
    func lessAvoid(_ a: Product, _ b: Product) -> Bool {
        return Ingridients.Shampoo.check(a).count < Ingridients.Shampoo.check(b).count
    }
}

struct TescoShampooView_Previews: PreviewProvider {
    static var previews: some View {
        TescoShampooView()
    }
}
