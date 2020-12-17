//
//  ETFDetailRow.swift
//  ark_invest
//
//  Created by SHUHUI YANG on 12/14/20.
//  Copyright © 2020 SHUHUI YANG. All rights reserved.
//

import SwiftUI

struct ETFDetailRow: View {
    var etfDetail: ETFDetailModel
    
    var body: some View {
            HStack {
                GeometryReader { gp in
                    let height: CGFloat = 30
                    Text(etfDetail.name).frame(width: gp.size.width / 3, height: height , alignment: .leading).lineLimit(1)
                                        
                    Text(etfDetail.ticker).frame(width: gp.size.width, height: height, alignment: .center)
                                        
//                    switch etfDetail.delta.deltaEnum {
//                    case .deltaUp:
//                        Text(etfDetail.delta.deltaVal).frame(width: gp.size.width, height: height, alignment: .trailing).background(Color.green)
//                    case .noChange:
//                        Text(etfDetail.delta.deltaVal).frame(width: gp.size.width, height: height, alignment: .trailing)
//                    case .deltaDown:
//                        Text(etfDetail.delta.deltaVal).frame(width: gp.size.width, height: height, alignment: .trailing).background(Color.red)
//                    case .remove:
//                        Text(etfDetail.delta.deltaVal).frame(width: gp.size.width, height: height, alignment: .trailing).background(Color.grey)
//                    case .newAdded:
//                        Text(etfDetail.delta.deltaVal).frame(width: gp.size.width, height: height, alignment: .trailing).background(Color.yellow)
//
//                    }
                    Text(etfDetail.percentage).frame(width: gp.size.width, height: height, alignment: .trailing)
                }
                .onTapGesture {
                    if let url = URL(string: etfDetail.url) {
                        UIApplication.shared.open(url)
                    }
                }
            }
        }
}
