//
//  ETFDetailModels.swift
//  ark_invest
//
//  Created by SHUHUI YANG on 12/15/20.
//  Copyright © 2020 SHUHUI YANG. All rights reserved.
//

import Foundation
import SwiftCSV

class ETFDetailsModels: ObservableObject {
    
    @Published var etfDetails: [ETFDetailModel] = []
    
    init(etfModel: ETFModel) {
        download(etfModel: etfModel)
    }
    
    func download(etfModel: ETFModel) {
        let currentDic = UserDefaults.standard.dictionary(forKey: etfModel.name)
        let oldTimeStamp = UserDefaults.standard.integer(forKey: "TIMESTAMP")
        if (currentDic != nil || Int(NSDate().timeIntervalSince1970) - oldTimeStamp <= 86400) {
            print(Int(NSDate().timeIntervalSince1970))
            let tickers = currentDic!["ticker"] as! Array<String>
            let weights = currentDic!["weight(%)"] as! Array<String>
            let companies = currentDic!["company"] as! Array<String>
//            let deltas = UserDefaults.standard.array(forKey: etfModel.name + "-Delta")
            let deltaModel = DeltaModel(id: 0, deltaEnum: DeltaEnum.noChange, deltaVal: "0")
            for i in 0 ..< companies.count {
                if (i >= weights.count || i >= tickers.count) {
                    self.etfDetails.append(ETFDetailModel.init(id: i, name: companies[i], ticker: "", percentage: "", url: "https://robinhood.com/applink/instrument/?symbol=" + "", delta: deltaModel))
                } else {
                    self.etfDetails.append(ETFDetailModel.init(id: i, name: companies[i], ticker: tickers[i], percentage: weights[i], url: "https://robinhood.com/applink/instrument/?symbol=" + tickers[i], delta: deltaModel))
                }
            }
        } else {
            print("fetch from remote")
            if (URL.init(string: etfModel.url) == nil) {
                return
            }
            let downloadTask = URLSession.shared.downloadTask(with: URL.init(string: etfModel.url)!) {
                urlOrNil, responseOrNil, errorOrNil in
                // check for and handle errors:
                // * errorOrNil should be nil
                // * responseOrNil should be an HTTPURLResponse with statusCode in 200..<299
                
                guard let fileURL = urlOrNil else { return }
                do {
                    let documentsURL = try
                        FileManager.default.url(for: .documentDirectory,
                                                in: .userDomainMask,
                                                appropriateFor: nil,
                                                create: false)
                    let savedURL = documentsURL.appendingPathComponent(fileURL.lastPathComponent)
                    try FileManager.default.moveItem(at: fileURL, to: savedURL)
                    let csvFile: CSV = try CSV(url: savedURL)
                    
                    let dictionary = csvFile.namedColumns as Dictionary<String, Any>
                    let tickers = dictionary["ticker"] as! Array<String>
                    let weights = dictionary["weight(%)"] as! Array<String>
                    let companies = dictionary["company"] as! Array<String>
                    let cusips = dictionary["cusip"] as! Array<String>
                    var deltas : [DeltaModel] = []
                    for i in 0 ..< companies.count {
                        if (currentDic != nil) {
                            let currentTickers = currentDic!["ticker"] as! Array<String>
                            let currentWeights = currentDic!["weight(%)"] as! Array<String>
                            let currentCompanies = currentDic!["company"] as! Array<String>
                            let currentCusips = currentDic!["cusip"] as! Array<String>
                            let deltaModel = DeltaModel(id: i, deltaEnum: DeltaEnum.noChange, deltaVal: "0")
                            if (i >= weights.count || i >= tickers.count) {
                                self.etfDetails.append(ETFDetailModel.init(id: i, name: companies[i], ticker: "", percentage: "", url: "https://robinhood.com/applink/instrument/?symbol=" + "", delta: deltaModel))
                                deltas.append(deltaModel)
                            } else {
                                let index = currentCusips.firstIndex(of: cusips[i])
                                var delta : DeltaModel
                                if (index == nil) {
                                    delta = DeltaModel(id: i, deltaEnum: DeltaEnum.newAdded, deltaVal: weights[i])
                                } else {
                                    let oldWeight = Float(currentWeights[index!])
                                    let newWeight = Float(weights[i])
                                    if (newWeight! > oldWeight!) {
                                        delta = DeltaModel(id: i, deltaEnum: DeltaEnum.deltaUp, deltaVal: String(newWeight! - oldWeight!))
                                    } else {
                                        delta = DeltaModel(id: i, deltaEnum: DeltaEnum.deltaDown, deltaVal: String(oldWeight! - newWeight!))
                                    }
                                }
                                self.etfDetails.append(ETFDetailModel.init(id: i, name: companies[i], ticker: tickers[i], percentage: weights[i], url: "https://robinhood.com/applink/instrument/?symbol=" + tickers[i], delta: delta))
                                deltas.append(delta)
                            }
                        } else {
                            let deltaModel = DeltaModel(id: i, deltaEnum: DeltaEnum.noChange, deltaVal: "0")
                            if (i >= weights.count || i >= tickers.count) {
                                self.etfDetails.append(ETFDetailModel.init(id: i, name: companies[i], ticker: "", percentage: "", url: "https://robinhood.com/applink/instrument/?symbol=" + "", delta: deltaModel))
                            } else {
                                self.etfDetails.append(ETFDetailModel.init(id: i, name: companies[i], ticker: tickers[i], percentage: weights[i], url: "https://robinhood.com/applink/instrument/?symbol=" + tickers[i], delta: deltaModel))
                            }
                            deltas.append(deltaModel)
                        }
                    }
                    
                    if (currentDic != nil) {
                        let currentCusips = currentDic!["cusip"] as! Array<String>
                        for i in 0 ..< currentCusips.count {
                            let cusip = currentCusips[i]
                            if (cusips.firstIndex(of: cusip) == nil) {
                                // recently removed
                            }
                        }
                    }
                    
                    let deltaArr : [DeltaModel] = deltas
//                    UserDefaults.standard.set(deltaArr, forKey: etfModel.name + "-Delta")
                    UserDefaults.standard.set(dictionary, forKey: etfModel.name)
                    
                } catch {
                    print ("file error: \(error)")
                }
            }
            downloadTask.resume()
        }
    }
}
