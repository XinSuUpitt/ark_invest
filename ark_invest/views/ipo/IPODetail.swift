//
//  IPODetail.swift
//  ark_invest
//
//  Created by SHUHUI YANG on 12/16/20.
//  Copyright © 2020 SHUHUI YANG. All rights reserved.
//

import Foundation
import SwiftUI

struct IPODetail: View {
    var ipo: IPOModel
    
    @ObservedObject private var ipoList: IPODetailModels
    
    init(ipo: IPOModel) {
        self.ipo = ipo
        self.ipoList = IPODetailModels(ipoModel: ipo)
    }
        
    var body: some View {
        List(ipoList.ipoList) { ipoitem in
            IPODetailRow(ipoDetail: ipoitem)
        }
        .navigationBarTitle(Text(ipo.name), displayMode: .inline)
    }
}
