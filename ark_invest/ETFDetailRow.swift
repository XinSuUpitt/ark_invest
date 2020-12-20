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
                                        
                    Text(etfDetail.ticker).position(CGPoint(x: gp.size.width * 0.45, y: height/2))
                    
                    if (etfDetail.delta.deltaEnum != DeltaEnum.remove) {
                        Text(etfDetail.percentage).position(CGPoint(x: gp.size.width * 2 / 3, y: height/2))
                    }
                    
                    if (etfDetail.delta.deltaEnum != DeltaEnum.remove) {
                        Text(etfDetail.delta.deltaVal).position(CGPoint(x: gp.size.width * 5 / 6 + 20, y: height/2)).foregroundColor(etfDetail.getColor())
                    }
                    
                    if (etfDetail.delta.deltaEnum == DeltaEnum.deltaUp) {
                        Image("arrow_up").renderingMode(.template).foregroundColor(Color.green)
                            .position(CGPoint(x: gp.size.width * 5 / 6, y: height/2))
                    }
                    
                    if (etfDetail.delta.deltaEnum == DeltaEnum.deltaDown) {
                        Image("arrow_down").renderingMode(.template).foregroundColor(Color.red)
                            .position(CGPoint(x: gp.size.width * 5 / 6, y: height/2))
                    }
                    
                    if (etfDetail.delta.deltaEnum == DeltaEnum.newAdded) {
                        Text("NEW").foregroundColor(Color.green)
                            .position(CGPoint(x: gp.size.width * 5 / 6, y: height/2))
                    }
                                        
                }
                .onTapGesture {
                    if let url = URL(string: etfDetail.url) {
                        UIApplication.shared.open(url)
                    }
                }
            }
        }
}
