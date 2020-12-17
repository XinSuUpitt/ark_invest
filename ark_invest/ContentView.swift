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
    var body: some View {
        ETFList()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
