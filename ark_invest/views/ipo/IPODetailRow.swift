//
//  IPODetailRow.swift
//  ark_invest
//
//  Created by SHUHUI YANG on 12/16/20.
//  Copyright © 2020 SHUHUI YANG. All rights reserved.
//

import SwiftUI

struct IPODetailRow: View {
    var ipoDetail: IPODetailModel
    
    var body: some View {
        
        HStack {
            GeometryReader { gp in
                let height: CGFloat = 30
                Text(ipoDetail.name).frame(width: gp.size.width / 3, height: height , alignment: .leading).lineLimit(1)
                                    
                Text(ipoDetail.ticker).frame(width: gp.size.width, height: height, alignment: .center)
                
                Text(ipoDetail.date).frame(width: gp.size.width, height: height, alignment: .trailing)
            }
            .onTapGesture {
                if let url = URL(string: ipoDetail.url) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
}
