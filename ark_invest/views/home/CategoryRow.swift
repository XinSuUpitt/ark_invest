//
//  CategoryRow.swift
//  ark_invest
//
//  Created by SHUHUI YANG on 12/19/20.
//  Copyright © 2020 SHUHUI YANG. All rights reserved.
//

import SwiftUI

struct CategoryRow: View {
    
    var section: HomePageItemModel
    
    let ipoItems = homeItemIPOs
    let etfItems = homeItemETFs
    
    var body: some View {
                
        VStack(alignment: .leading) {
            Text(section.name)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            
            if (section.id == 0) {
                let items = section.content as! [HomeItem]
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 0) {
                        ForEach(items) { webitem in
                            WebItem(web: webitem)
                        }
                    }
                }
                .frame(height: 185)
            }

            if (section.id == 1) {
                let items: [IPOModel] = section.content as! [IPOModel]
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 0) {
                        ForEach(items) { ipoitem in
                            NavigationLink(destination: IPODetail(ipo: ipoitem)) {
                                IPOItem(ipo: ipoItems[ipoitem.id])
                            }
                        }
                    }
                }
                .frame(height: 185)
            }
            
            if (section.id == 2) {
                let items: [ETFModel] = section.content as! [ETFModel]
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ForEach(items) { etfitem in
                            NavigationLink(destination: ETFDetail(etf: etfitem)) {
                                ETFItem(etf: etfItems[etfitem.id], model: etfitem)
                            }
                        }
                    }
                }
            }
        }
    }
}
