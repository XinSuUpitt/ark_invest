//
//  ETFRow.swift
//  ark_invest
//
//  Created by SHUHUI YANG on 12/14/20.
//  Copyright © 2020 SHUHUI YANG. All rights reserved.
//

import SwiftUI

struct ETFRow: View {
    var etf: ETFModel
    
    var body: some View {
            HStack {
                
                Text(etf.name)
                Spacer()
            }
        }
}

struct ETFRow_Previews: PreviewProvider {
    static var previews: some View {
        ETFRow(etf: etfs[1])
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
