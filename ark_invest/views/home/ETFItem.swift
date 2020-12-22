//
//  ETFItem.swift
//  ark_invest
//
//  Created by SHUHUI YANG on 12/19/20.
//  Copyright © 2020 SHUHUI YANG. All rights reserved.
//

import SwiftUI

struct ETFItem: View {
    var etf: HomeItem
    
    @State var showTrading = false

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Image(etf.image)
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFill()
                    .frame(width: .infinity, height: 155)
                    .cornerRadius(5)
            }
            .padding(.leading, 15)
            .padding(.trailing, 15)
            
            Text(etf.name)
                .foregroundColor(.primary)
                .font(.system(size: 35, weight: .bold, design: .serif))
                .onTapGesture{}
                .onLongPressGesture {
                    self.showTrading = true
                }
                .sheet(isPresented: $showTrading) {
                    SafariView(url: URL(string: "https://cathiesark.com/" + etf.name.lowercased() + "/trades")!).edgesIgnoringSafeArea(.all)
                }
        }
    }
}
