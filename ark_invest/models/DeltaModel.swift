//
//  DeltaModel.swift
//  ark_invest
//
//  Created by SHUHUI YANG on 12/15/20.
//  Copyright © 2020 SHUHUI YANG. All rights reserved.
//

import Foundation

struct DeltaModel: Hashable, Identifiable {
    var id: Int
    var deltaEnum: DeltaEnum
    var deltaVal: String
}
