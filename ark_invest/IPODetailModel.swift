//
//  IPODetailModel.swift
//  ark_invest
//
//  Created by SHUHUI YANG on 12/16/20.
//  Copyright © 2020 SHUHUI YANG. All rights reserved.
//

import Foundation

struct IPODetailModel: Hashable, Identifiable {
    var id: Int
    var name: String
    var ticker: String
    var date: String
    var url: String
    var price: String
}
