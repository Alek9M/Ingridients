//
//  IngridientsSection.swift
//  Ingridients
//
//  Created by M on 11/03/2024.
//

import SwiftUI

struct IngridientsSection: View {
    
    let title: LocalizedStringKey
    var ingridients: [Ingridient]
    
    var body: some View {
        Section(title) {
            ForEach(ingridients) { ingridient in
                Text(ingridient.title.presentable)
            }
            .if(OS.isMacOS) {
                $0
                    .padding(.horizontal)
                    .padding(.vertical, 0.5)
            }
        }
    }
}

//#Preview {
//    IngridientsSection()
//}
