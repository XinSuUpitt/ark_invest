//
//  ResourcesList.swift
//  ark_invest
//
//  Created by SHUHUI YANG on 12/19/20.
//  Copyright © 2020 SHUHUI YANG. All rights reserved.
//

import Foundation
import SwiftUI

struct ResourcesList: View {
    
    let pageList = resourceWebPages as! [HomeItem]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(pageList) { page in
                    ResourcesPageItem(web: page)
                }
            }.navigationTitle("Related Links")
        }
        
    }
}
