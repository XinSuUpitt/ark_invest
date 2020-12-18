//
//  ETFList.swift
//  ark_invest
//
//  Created by SHUHUI YANG on 12/14/20.
//  Copyright © 2020 SHUHUI YANG. All rights reserved.
//

import SwiftUI

struct ETFList: View {
    let items: [HomePageItemModel] = [HomePageItemModel(id: 0, name: "ETF", content: etfs), HomePageItemModel(id: 1, name: "IPO", content: ipos)]
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { section in
                    Section(header: Text(section.name)) {
                        if (section.id == 0) {
                            let content = section.content as! [ETFModel]
                            ForEach(content) { etfitem in
                                NavigationLink(destination: ETFDetail(etf: etfitem)) {
                                    ETFRow(etf: etfitem)
                                }
                            }
                        } else if (section.id == 1) {
                            let content = section.content as! [IPOModel]
                            ForEach(content) { ipoitem in
                                NavigationLink(destination: IPODetail(ipo: ipoitem)) {
                                    IPORow(ipo: ipoitem)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Ark Invest")
        }
    }
}
