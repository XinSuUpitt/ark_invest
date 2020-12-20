//
//  IPORow.swift
//  ark_invest
//
//  Created by SHUHUI YANG on 12/16/20.
//  Copyright © 2020 SHUHUI YANG. All rights reserved.
//

import SwiftUI

struct IPORow: View {
    var ipo: IPOModel
    
    var body: some View {
        HStack {
            Text(ipo.name)
            Spacer()
        }
    }
}
