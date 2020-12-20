//
//  CategoryItem.swift
//  ark_invest
//
//  Created by SHUHUI YANG on 12/19/20.
//  Copyright © 2020 SHUHUI YANG. All rights reserved.
//

import SwiftUI

struct IPOItem: View {
    var ipo: HomeItem

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Image(ipo.image)
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 155)
                    .cornerRadius(5)
            }
            .padding(.leading, 15)
            
            Text(ipo.name)
                .foregroundColor(.primary)
                .font(.system(size: 35, weight: .bold, design: .serif))
        }
    }
}
