//
//  ETFDetailModel.swift
//  ark_invest
//
//  Created by SHUHUI YANG on 12/14/20.
//  Copyright © 2020 SHUHUI YANG. All rights reserved.
//

import Foundation
import SwiftUI

struct ETFDetailModel: Hashable, Identifiable {
    var id: Int
    var name: String
    var ticker: String
    var percentage: String
    var url: String
    var delta: DeltaModel
    var fund: String
    
    func getColor() -> Color {
        switch delta.deltaEnum {
            case .deltaUp:
                return Color.green
            case .noChange:
                return Color.primary
            case .deltaDown:
                return Color.red
            case .remove:
                return Color.gray
            case .newAdded:
                return Color.blue
        }
    }
    
    func getValue() -> String {
        let deltaVal: String = delta.deltaVal
        let floatVal = abs(Float(deltaVal)!) * 100
        let res: String = String(format: "%.2f%%", floatVal)
        return res
    }
}
