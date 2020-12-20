//
//  Company.swift
//  ark_invest
//
//  Created by SHUHUI YANG on 12/17/20.
//  Copyright © 2020 SHUHUI YANG. All rights reserved.
//

import Foundation

struct Company: Hashable, Identifiable {
    var id: Int
    var cusip: String
    var name: String
    var ticker: String
    var shares: String
    var marketValue: String
    var weight: String
    var url: String
    var delta: Float
    var timeStamp: Int
}
