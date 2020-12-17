//
//  ETFDetailModel.swift
//  ark_invest
//
//  Created by SHUHUI YANG on 12/14/20.
//  Copyright © 2020 SHUHUI YANG. All rights reserved.
//

import Foundation

struct ETFDetailModel: Hashable, Identifiable {
    var id: Int
    var name: String
    var ticker: String
    var percentage: String
    var url: String
    var delta: DeltaModel
}
