//
//  IPODetailsModels.swift
//  ark_invest
//
//  Created by SHUHUI YANG on 12/16/20.
//  Copyright © 2020 SHUHUI YANG. All rights reserved.
//

import Foundation

class IPODetailModels: ObservableObject {
    
    @Published var ipoList: [IPODetailModel] = []
    
    init(ipoModel: IPOModel) {
        fetch(ipoModel: ipoModel)
    }
    
    func fetch(ipoModel: IPOModel) {
        
        let lastWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let lastWeekDateString = dateFormatter.string(from: lastWeekDate)
        
        let nextWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date())!
        let nextWeekDateString = dateFormatter.string(from: nextWeekDate)
        
        let url = URL(string: "https://finnhub.io/api/v1/calendar/ipo?from=" + lastWeekDateString + "&to=" + nextWeekDateString + "&token=bvdfr6f48v6tkd6gm0eg")

        var request = URLRequest(url: url!)

        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }

            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            
            if let object = json as? Dictionary<String, AnyObject> {
                let arrays = object["ipoCalendar"]
                
                if (arrays == nil) {
                    return
                }
                
                for item in arrays as! [Dictionary<String, Any>] {
                    var date = item["date"] as? String
                    var name = item["name"] as? String
                    var price = item["price"] as? String
                    var ticker = item["symbol"] as? String
                    if (date == nil) {
                        date = ""
                    }
                    if (name == nil) {
                        name = ""
                    }
                    if (price == nil) {
                        price = ""
                    }
                    if (ticker == nil) {
                        ticker = ""
                    }
                    
                    if (ipoModel.id == 0) {
                        self.isChinaCompany(ticker: ticker!) { china in
                            if (china == true) {
                                self.ipoList.append(IPODetailModel(id: arrays?.index(of: item) ?? 0, name: name ?? "", ticker: ticker ?? "", date: date ?? "", url: "https://robinhood.com/applink/instrument/?symbol=" + ticker!, price: price ?? ""))
                            }
                        }
                    } else {
                        self.ipoList.append(IPODetailModel(id: arrays?.index(of: item) ?? 0, name: name ?? "", ticker: ticker ?? "", date: date ?? "", url: "https://robinhood.com/applink/instrument/?symbol=" + ticker!, price: price ?? ""))
                    }
                }
            } else {
                print("Json is invalid")
            }
        }

        task.resume()
    }
    
    func isChinaCompany(ticker: String, completion: @escaping (Bool)->() ) {

        let country = UserDefaults.standard.value(forKey: ticker) as? String
        if (country != nil) {
            let result = country ?? ""
//            print("Find country %s %s", result, ticker)
            completion(result == "CN")
            return
        }
        let url = URL(string: "https://finnhub.io/api/v1/stock/profile2?symbol=" + ticker + "&token=bvdfr6f48v6tkd6gm0eg")

        var request = URLRequest(url: url!)

        request.addValue("application/json", forHTTPHeaderField: "Accept")
        var isChinese = false
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }

            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            
            if let object = json as? Dictionary<String, AnyObject> {
                
                var country = object["country"] as? String
                if (country == nil) {
                    country == ""
                }
                
                let result = country ?? ""
                UserDefaults.standard.set(result, forKey: ticker)
                print("fetch country %s %s", result, ticker)
                if (result == "CN") {
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                print("Json is invalid")
                completion(false)
            }
        }

        task.resume()
    }
}
