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
    
    @Published var etfDetails: [ETFDetailPageSectionModel] = []
    var etfDetailModels: [ETFDetailModel] = []
    var removedEtfDetails: [ETFDetailModel] = []
    
    init(etfModel: ETFModel) {
        download(etfModel: etfModel)
    }
    
    func download(etfModel: ETFModel) {
        
//        print("fetch from remote")
        if (URL.init(string: etfModel.url) == nil) {
            return
        }
        // Fetch data from remote csv files
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
                let shares = dictionary["shares"] as! Array<String>
                let date = dictionary["date"] as! Array<String>
                let marketValues = dictionary["market value($)"] as! Array<String>
                let fund = dictionary["fund"] as! Array<String>
                            
//                print(dictionary)
                let mutableTickers = NSMutableArray(array: tickers)
                let mutableWeights = NSMutableArray(array: weights)
                let mutableCompanies = NSMutableArray(array: companies)
                let mutableCusips = NSMutableArray(array: cusips)
                let mutableShares = NSMutableArray(array: shares)
                let mutableMarketValues = NSMutableArray(array: marketValues)
                let mutableDelta = NSMutableArray()
                let mutableDate = NSMutableArray(array: date)
                let mutableFund = NSMutableArray(array: fund)
                
                for _ in 0 ..< 3 {
                    mutableTickers.removeLastObject()
                    mutableWeights.removeLastObject()
                    mutableCompanies.removeLastObject()
                    mutableCusips.removeLastObject()
                    mutableShares.removeLastObject()
                    mutableMarketValues.removeLastObject()
                    mutableDate.removeLastObject()
                    mutableFund.removeLastObject()
                }
                
                var oldCompanyDict = UserDefaults.standard.dictionary(forKey: etfModel.name)
                
                if (oldCompanyDict != nil) {
                    let oldDate = oldCompanyDict!["date"] as! Array<String>
                    if (date[0] == oldDate[0]) {
//                        print("Same date, no need to fetch new")
                        let tickers = oldCompanyDict!["ticker"] as! Array<String>
                        let weights = oldCompanyDict!["weight(%)"] as! Array<String>
                        let companies = oldCompanyDict!["company"] as! Array<String>
                        let cusips = oldCompanyDict!["cusip"] as! Array<String>
                        let shares = oldCompanyDict!["shares"] as! Array<String>
                        let marketValues = oldCompanyDict!["market value($)"] as! Array<String>
                        let oldDelta = oldCompanyDict!["delta"] as! Array<String>
                        let oldFund = oldCompanyDict!["fund"] as! Array<String>
                        
                        for i in 0 ..< cusips.count {
                            if (weights[i] == "0") {
                                let model = ETFDetailModel(id: i, name: companies[i], ticker: tickers[i], percentage: weights[i], url: "https://robinhood.com/applink/instrument/?symbol=" + tickers[i], delta: DeltaModel(id: i, deltaEnum: DeltaEnum.remove, deltaVal: "0"), fund: oldFund[i])
                                self.removedEtfDetails.append(model)
                            } else {
                                let delta: Float = Float(oldDelta[i])!
                                var model: ETFDetailModel
                                if (delta == 100) {
                                    model = ETFDetailModel(id: i, name: companies[i], ticker: tickers[i], percentage: weights[i], url: "https://robinhood.com/applink/instrument/?symbol=" + tickers[i], delta: DeltaModel(id: i, deltaEnum: DeltaEnum.newAdded, deltaVal: String(describing: weights[i])), fund: oldFund[i])
                                } else if (delta == 0) {
                                    model = ETFDetailModel(id: i, name: companies[i], ticker: tickers[i], percentage: weights[i], url: "https://robinhood.com/applink/instrument/?symbol=" + tickers[i], delta: DeltaModel(id: i, deltaEnum: DeltaEnum.noChange, deltaVal: "0"), fund: oldFund[i])
                                } else if (delta > 0) {
                                    model = ETFDetailModel(id: i, name: companies[i], ticker: tickers[i], percentage: weights[i], url: "https://robinhood.com/applink/instrument/?symbol=" + tickers[i], delta: DeltaModel(id: i, deltaEnum: DeltaEnum.deltaUp, deltaVal: String(describing: delta)), fund: oldFund[i])
                                } else {
                                    model = ETFDetailModel(id: i, name: companies[i], ticker: tickers[i], percentage: weights[i], url: "https://robinhood.com/applink/instrument/?symbol=" + tickers[i], delta: DeltaModel(id: i, deltaEnum: DeltaEnum.deltaDown, deltaVal: String(describing: delta)), fund: oldFund[i])
                                }
                                self.etfDetailModels.append(model)
                            }
                        }
                        
                        if (self.removedEtfDetails.count == 0) {
                            self.removedEtfDetails.append(ETFDetailModel(id: 0, name: "N/A", ticker: "", percentage: "", url: "https://robinhood.com/applink/instrument/?symbol=", delta: DeltaModel(id: 0, deltaEnum: DeltaEnum.remove, deltaVal: ""), fund: oldFund[0]))
                        }
                        self.etfDetails.append(ETFDetailPageSectionModel(id: 0, name: "Recently Removed", content: self.removedEtfDetails))
                        self.etfDetails.append(ETFDetailPageSectionModel(id: 1, name: "Current", content: self.etfDetailModels))
                        
                        return
                    }
                }
                
                for i in 0 ..< cusips.count {
                    if (cusips[i] == nil || cusips[i] == "") {
                        continue
                    }
                    // First time fetch
                    if (oldCompanyDict == nil) {
//                        print("First time fetch")
                        let model = ETFDetailModel(id: i, name: companies[i], ticker: tickers[i], percentage: weights[i], url: "https://robinhood.com/applink/instrument/?symbol=" + tickers[i], delta: DeltaModel(id: i, deltaEnum: DeltaEnum.noChange, deltaVal: "0"), fund: fund[i])
                        self.etfDetailModels.append(model)
                        mutableDelta.add("0")
                    } else {
                        // Fetch new
//                        print("Fetch new")
                        let oldTickers = oldCompanyDict!["ticker"] as! Array<String>
                        let oldWeights = oldCompanyDict!["weight(%)"] as! Array<String>
                        let oldCompanies = oldCompanyDict!["company"] as! Array<String>
                        let oldCusips = oldCompanyDict!["cusip"] as! Array<String>
                        let oldShares = oldCompanyDict!["shares"] as! Array<String>
                        let oldMarketValues = oldCompanyDict!["market value($)"] as! Array<String>
                        let oldDate = oldCompanyDict!["date"] as! Array<String>
                        let oldFund = oldCompanyDict!["fund"] as! Array<String>
                        
                        var newAdded: Bool = true
                        for j in 0 ..< oldCusips.count {
                            if (oldCusips[j] == cusips[i]) {
                                newAdded = false
                            }
                        }
                        if (newAdded) {
                            let model = ETFDetailModel(id: i, name: companies[i], ticker: tickers[i], percentage: weights[i], url: "https://robinhood.com/applink/instrument/?symbol=" + tickers[i], delta: DeltaModel(id: i, deltaEnum: DeltaEnum.newAdded, deltaVal: weights[i]), fund: fund[i])
                            self.etfDetailModels.append(model)
                            mutableDelta.add(String(describing: "100"))
                        } else {
                            let idx: Int = oldCusips.firstIndex(of: cusips[i])!
                            let delta = Float(weights[i])! - Float(oldWeights[idx])!
                            var model: ETFDetailModel
                            if (delta == 0) {
                                model = ETFDetailModel(id: i, name: companies[i], ticker: tickers[i], percentage: weights[i], url: "https://robinhood.com/applink/instrument/?symbol=" + tickers[i], delta: DeltaModel(id: i, deltaEnum: DeltaEnum.noChange, deltaVal: "0"), fund: fund[i])
                            } else if (delta > 0) {
                                model = ETFDetailModel(id: i, name: companies[i], ticker: tickers[i], percentage: weights[i], url: "https://robinhood.com/applink/instrument/?symbol=" + tickers[i], delta: DeltaModel(id: i, deltaEnum: DeltaEnum.deltaUp, deltaVal: String(describing: delta)), fund: fund[i])
                            } else {
                                model = ETFDetailModel(id: i, name: companies[i], ticker: tickers[i], percentage: weights[i], url: "https://robinhood.com/applink/instrument/?symbol=" + tickers[i], delta: DeltaModel(id: i, deltaEnum: DeltaEnum.deltaDown, deltaVal: String(describing: delta)), fund: fund[i])
                            }
                            mutableDelta.add(String(describing: delta))
                            self.etfDetailModels.append(model)
                        }
                    }
                }
                
                if (oldCompanyDict != nil) {
                    let oldTickers = oldCompanyDict!["ticker"] as! Array<String>
                    let oldWeights = oldCompanyDict!["weight(%)"] as! Array<String>
                    let oldCompanies = oldCompanyDict!["company"] as! Array<String>
                    let oldCusips = oldCompanyDict!["cusip"] as! Array<String>
                    let oldDate = oldCompanyDict!["date"] as! Array<String>
                    let oldFund = oldCompanyDict!["fund"] as! Array<String>
                    for i in 0 ..< oldCusips.count {
                        if (cusips.firstIndex(of: oldCusips[i]) == nil) {
                            let model = ETFDetailModel(id: oldCusips.count + i, name: oldCompanies[i], ticker: oldTickers[i], percentage: oldWeights[i], url: "https://robinhood.com/applink/instrument/?symbol=" + oldTickers[i], delta: DeltaModel(id: i, deltaEnum: DeltaEnum.remove, deltaVal: "0"), fund: oldFund[i])
                            self.removedEtfDetails.append(model)
                            mutableCusips.add(oldCusips[i])
                            mutableShares.add("0")
                            mutableTickers.add(oldTickers[i])
                            mutableWeights.add("0")
                            mutableCompanies.add(oldCompanies[i])
                            mutableMarketValues.add("0")
                            mutableDelta.add("0")
                            mutableDate.add(oldDate[i])
                            mutableFund.add(oldFund[i])
                        }
                    }
                }
                
                let newDict = ["ticker": mutableTickers, "weight(%)": mutableWeights, "company": mutableCompanies, "cusip": mutableCusips, "shares": mutableShares, "market value($)": mutableMarketValues, "delta": mutableDelta, "date": mutableDate, "fund": mutableFund]
                
                if (self.removedEtfDetails.count == 0) {
                    self.removedEtfDetails.append(ETFDetailModel(id: 0, name: "N/A", ticker: "", percentage: "", url: "https://robinhood.com/applink/instrument/?symbol=", delta: DeltaModel(id: 0, deltaEnum: DeltaEnum.remove, deltaVal: ""), fund: ""))
                }
                self.etfDetails.append(ETFDetailPageSectionModel(id: 0, name: "Recently Removed", content: self.removedEtfDetails))
                self.etfDetails.append(ETFDetailPageSectionModel(id: 1, name: "Current", content: self.etfDetailModels))
                    
                UserDefaults.standard.set(newDict, forKey: etfModel.name)
            } catch {
                print ("file error: \(error)")
            }
        }
        downloadTask.resume()
    }
}
