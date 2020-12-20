//
//  ETFDetail.swift
//  ark_invest
//
//  Created by SHUHUI YANG on 12/14/20.
//  Copyright © 2020 SHUHUI YANG. All rights reserved.
//

import SwiftUI
import PDFKit
import SwiftCSV

struct ETFDetail: View {
    var etf: ETFModel
    
    @ObservedObject private var etfDetails: ETFDetailsModels
    
    init(etf: ETFModel) {
        self.etf = etf
        self.etfDetails = ETFDetailsModels(etfModel: etf)
    }
        
    var body: some View {
        List {
            ForEach(etfDetails.etfDetails) { section in
                Section(header: Text(section.name)) {
                    let content = section.content as! [ETFDetailModel]
                    ForEach(content) { etfitem in
                        ETFDetailRow(etfDetail: etfitem)
                    }
                }
                
            }
        }
        .navigationBarTitle(Text(etf.name), displayMode: .inline)
    }
}

struct ETFDetail_Previews: PreviewProvider {
    static var previews: some View {
        ETFDetail(etf: etfs[0])
    }
}
