//
//  ContentView.swift
//  ark_invest
//
//  Created by SHUHUI YANG on 12/11/20.
//  Copyright © 2020 SHUHUI YANG. All rights reserved.
//

import SwiftUI
import PDFKit
import Foundation
import SwiftCSV

struct ContentView: View {
    
    @State private var selection: Tab = .home

    enum Tab {
        case home
        case resources
    }
    
    var body: some View {
        TabView(selection: $selection) {
            CategoryHome()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(Tab.home)

            ResourcesList()
                .tabItem {
                    Label("Resources", systemImage: "list.bullet")
                }
                .tag(Tab.resources)
        }
        
//        ETFList()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
