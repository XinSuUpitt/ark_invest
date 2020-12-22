//
//  WebItem.swift
//  ark_invest
//
//  Created by SHUHUI YANG on 12/19/20.
//  Copyright © 2020 SHUHUI YANG. All rights reserved.
//

import SwiftUI
import SafariServices

struct WebItem: View {
    var web: HomeItem
    
    @State var showSafariView = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Image(web.image)
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 155)
                    .cornerRadius(5)
                    .blur(radius: 5)
            }
            .padding(.leading, 15)
            
            Text(web.name)
                .foregroundColor(.primary)
                .font(.system(size: 35, weight: .bold, design: .serif))
            
        }
        .onTapGesture {
            self.showSafariView = true
        }
        .sheet(isPresented: $showSafariView) {
            SafariView(url: URL(string: web.url)!).edgesIgnoringSafeArea(.all)
        }
    }
}
