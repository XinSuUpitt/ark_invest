//
//  ResourcesPageItem.swift
//  ark_invest
//
//  Created by SHUHUI YANG on 12/19/20.
//  Copyright © 2020 SHUHUI YANG. All rights reserved.
//
import SwiftUI
import SafariServices

struct ResourcesPageItem: View {
    var web: HomeItem
    
    @State var showSafariView = false
    
    var body: some View {
        ZStack {
            Text(web.name)
                .foregroundColor(.primary)
                .font(.system(size: 18, weight: .light, design: .serif))
        }
        .onTapGesture {
            self.showSafariView = true
        }
        .sheet(isPresented: $showSafariView) {
            SafariView(url: URL(string: web.url)!).edgesIgnoringSafeArea(.all)
        }
    }
}
