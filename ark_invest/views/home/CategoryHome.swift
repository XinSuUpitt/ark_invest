//
//  CategoryHome.swift
//  ark_invest
//
//  Created by SHUHUI YANG on 12/19/20.
//  Copyright © 2020 SHUHUI YANG. All rights reserved.
//

import SwiftUI

struct CategoryHome: View {

    let items: [HomePageItemModel] = [HomePageItemModel(id: 0, name: "Featured WebPages", content: homeItemWebs), HomePageItemModel(id: 1, name: "IPO", content: ipos), HomePageItemModel(id: 2, name: "ETF", content: etfs)]

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { section in
                    CategoryRow(section: section)
                }
                .listRowInsets(EdgeInsets())
            }
            .navigationTitle("Ark Invest")
            
        }
    }
}
