//
//  ETFList.swift
//  ark_invest
//
//  Created by SHUHUI YANG on 12/14/20.
//  Copyright © 2020 SHUHUI YANG. All rights reserved.
//

import SwiftUI

struct ETFList: View {
    var body: some View {
        NavigationView {
            List(etfs) { etfitem in
                NavigationLink(destination: ETFDetail(etf: etfitem)) {
                    ETFRow(etf: etfitem)
                }
            }
            .navigationTitle("Ark Invest")
        }
    }
}
