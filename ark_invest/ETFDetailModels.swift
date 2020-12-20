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
        let oldCompanyDict = UserDefaults.standard.dictionary(forKey: etfModel.name)
        let oldTimeStamp = UserDefaults.standard.integer(forKey: "TIMESTAMP")
        // Less than one day, no need to fetch, directly return and use data from UserDefaults
        if (oldCompanyDict != nil || Int(NSDate().timeIntervalSince1970) - oldTimeStamp <= 86400) {
            
            let tickers = oldCompanyDict!["ticker"] as! Array<String>
            let weights = oldCompanyDict!["weight(%)"] as! Array<String>
            let companies = oldCompanyDict!["company"] as! Array<String>
            let cusips = oldCompanyDict!["cusip"] as! Array<String>
            let shares = oldCompanyDict!["shares"] as! Array<String>
            let marketValues = oldCompanyDict!["market value($)"] as! Array<String>
            let oldDelta = oldCompanyDict!["delta"] as! Array<String>

            
            for i in 0 ..< cusips.count {
                if (weights[i] == "0") {
                    let model = ETFDetailModel(id: i, name: companies[i], ticker: tickers[i], percentage: weights[i], url: "https://robinhood.com/applink/instrument/?symbol=" + tickers[i], delta: DeltaModel(id: i, deltaEnum: DeltaEnum.remove, deltaVal: "0"))
                    self.removedEtfDetails.append(model)
                } else {
                    let delta: Float = Float(oldDelta[i])!
                    var model: ETFDetailModel
                    if (delta == 0) {
                        model = ETFDetailModel(id: i, name: companies[i], ticker: tickers[i], percentage: weights[i], url: "https://robinhood.com/applink/instrument/?symbol=" + tickers[i], delta: DeltaModel(id: i, deltaEnum: DeltaEnum.noChange, deltaVal: "0"))
                    } else if (delta > 0) {
                        model = ETFDetailModel(id: i, name: companies[i], ticker: tickers[i], percentage: weights[i], url: "https://robinhood.com/applink/instrument/?symbol=" + tickers[i], delta: DeltaModel(id: i, deltaEnum: DeltaEnum.deltaUp, deltaVal: String(describing: delta)))
                    } else {
                        model = ETFDetailModel(id: i, name: companies[i], ticker: tickers[i], percentage: weights[i], url: "https://robinhood.com/applink/instrument/?symbol=" + tickers[i], delta: DeltaModel(id: i, deltaEnum: DeltaEnum.deltaDown, deltaVal: String(describing: delta)))
                    }
                    self.etfDetailModels.append(model)
                }
            }
            
            if (self.removedEtfDetails.count == 0) {
                self.removedEtfDetails.append(ETFDetailModel(id: 0, name: "N/A", ticker: "", percentage: "", url: "https://robinhood.com/applink/instrument/?symbol=", delta: DeltaModel(id: 0, deltaEnum: DeltaEnum.remove, deltaVal: "")))
            }
            self.etfDetails.append(ETFDetailPageSectionModel(id: 0, name: "Recently Removed", content: self.removedEtfDetails))
            self.etfDetails.append(ETFDetailPageSectionModel(id: 1, name: "Current", content: self.etfDetailModels))
        } else {
            print("fetch from remote")
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
                    let marketValues = dictionary["market value($)"] as! Array<String>
                    
                    let mutableTickers = NSMutableArray(array: tickers)
                    let mutableWeights = NSMutableArray(array: weights)
                    let mutableCompanies = NSMutableArray(array: companies)
                    let mutableCusips = NSMutableArray(array: cusips)
                    let mutableShares = NSMutableArray(array: shares)
                    let mutableMarketValues = NSMutableArray(array: marketValues)
                    let mutableDelta = NSMutableArray()
                    
                    for _ in 0 ..< 3 {
                        mutableTickers.removeLastObject()
                        mutableWeights.removeLastObject()
                        mutableCompanies.removeLastObject()
                        mutableCusips.removeLastObject()
                        mutableShares.removeLastObject()
                        mutableMarketValues.removeLastObject()
                    }
                    
                    for i in 0 ..< cusips.count {
                        if (cusips[i] == nil || cusips[i] == "") {
                            continue
                        }
                        // First time fetch
                        if (oldCompanyDict == nil) {
                            let model = ETFDetailModel(id: i, name: companies[i], ticker: tickers[i], percentage: weights[i], url: "https://robinhood.com/applink/instrument/?symbol=" + tickers[i], delta: DeltaModel(id: i, deltaEnum: DeltaEnum.noChange, deltaVal: "0"))
                            self.etfDetailModels.append(model)
                            mutableDelta.add("0")
                        } else {
                            // Update after 24 hours interval
                            let oldTickers = oldCompanyDict!["ticker"] as! Array<String>
                            let oldWeights = oldCompanyDict!["weight(%)"] as! Array<String>
                            let oldCompanies = oldCompanyDict!["company"] as! Array<String>
                            let oldCusips = oldCompanyDict!["cusip"] as! Array<String>
                            let oldShares = oldCompanyDict!["shares"] as! Array<String>
                            let oldMarketValues = oldCompanyDict!["market value($)"] as! Array<String>
                            
                            var newAdded: Bool = true
                            for j in 0 ..< oldCusips.count {
                                if (oldCusips[j] == cusips[i]) {
                                    newAdded = false
                                }
                            }
                            if (newAdded) {
                                let model = ETFDetailModel(id: i, name: companies[i], ticker: tickers[i], percentage: weights[i], url: "https://robinhood.com/applink/instrument/?symbol=" + tickers[i], delta: DeltaModel(id: i, deltaEnum: DeltaEnum.newAdded, deltaVal: "0"))
                                self.etfDetailModels.append(model)
                                mutableDelta.add(String(describing: weights[i]))
                            } else {
                                let idx: Int = oldCusips.firstIndex(of: cusips[i])!
                                let delta = Float(weights[i])! - Float(oldWeights[idx])!
                                var model: ETFDetailModel
                                if (delta == 0) {
                                    model = ETFDetailModel(id: i, name: companies[i], ticker: tickers[i], percentage: weights[i], url: "https://robinhood.com/applink/instrument/?symbol=" + tickers[i], delta: DeltaModel(id: i, deltaEnum: DeltaEnum.noChange, deltaVal: "0"))
                                } else if (delta > 0) {
                                    model = ETFDetailModel(id: i, name: companies[i], ticker: tickers[i], percentage: weights[i], url: "https://robinhood.com/applink/instrument/?symbol=" + tickers[i], delta: DeltaModel(id: i, deltaEnum: DeltaEnum.deltaUp, deltaVal: String(describing: delta)))
                                } else {
                                    model = ETFDetailModel(id: i, name: companies[i], ticker: tickers[i], percentage: weights[i], url: "https://robinhood.com/applink/instrument/?symbol=" + tickers[i], delta: DeltaModel(id: i, deltaEnum: DeltaEnum.deltaDown, deltaVal: String(describing: delta)))
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
                        for i in 0 ..< oldCusips.count {
                            if (cusips.firstIndex(of: oldCusips[i]) == nil) {
                                let model = ETFDetailModel(id: oldCusips.count + i, name: oldCompanies[i], ticker: oldTickers[i], percentage: oldWeights[i], url: "https://robinhood.com/applink/instrument/?symbol=" + oldTickers[i], delta: DeltaModel(id: i, deltaEnum: DeltaEnum.remove, deltaVal: "0"))
                                self.removedEtfDetails.append(model)
                                mutableCusips.add(oldCusips[i])
                                mutableShares.add("0")
                                mutableTickers.add(oldTickers[i])
                                mutableWeights.add("0")
                                mutableCompanies.add(oldCompanies[i])
                                mutableMarketValues.add("0")
                                mutableDelta.add("0")
                            }
                        }
                    }
                    
                    let newDict = ["ticker": mutableTickers, "weight(%)": mutableWeights, "company": mutableCompanies, "cusip": mutableCusips, "shares": mutableShares, "market value($)": mutableMarketValues, "delta": mutableDelta]
                    
                    if (self.removedEtfDetails.count == 0) {
                        self.removedEtfDetails.append(ETFDetailModel(id: 0, name: "N/A", ticker: "", percentage: "", url: "https://robinhood.com/applink/instrument/?symbol=", delta: DeltaModel(id: 0, deltaEnum: DeltaEnum.remove, deltaVal: "")))
                    }
                    self.etfDetails.append(ETFDetailPageSectionModel(id: 0, name: "Recently Removed", content: self.removedEtfDetails))
                    self.etfDetails.append(ETFDetailPageSectionModel(id: 1, name: "Current", content: self.etfDetailModels))
                        
                    UserDefaults.standard.set(newDict, forKey: etfModel.name)
                    UserDefaults.standard.set(Int(NSDate().timeIntervalSince1970), forKey: "TIMESTAMP")
                } catch {
                    print ("file error: \(error)")
                }
            }
            downloadTask.resume()
        }
    }
}
