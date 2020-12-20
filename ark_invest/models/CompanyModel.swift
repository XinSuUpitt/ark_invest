//
//  CompanyModel.swift
//  ark_invest
//
//  Created by SHUHUI YANG on 12/14/20.
//  Copyright © 2020 SHUHUI YANG. All rights reserved.
//

import Foundation

class CompanyModel {
    
    var defaults : UserDefaults
        
    init() {
        defaults = UserDefaults.standard
    }
    
    func save(dictionary: Dictionary<NSString, NSString>) {
        
    }
    
    func getCompanyByCUSIP() {
        let headers = [
            "x-rapidapi-key": "7d0908e8c7msh8e2404388c8d4cdp187a6ajsn2ab5abc793a5",
            "x-rapidapi-host": "apidojo-yahoo-finance-v1.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://apidojo-yahoo-finance-v1.p.rapidapi.com/auto-complete?q=88160R101&region=US")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    print(json)
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
            }
        })

        dataTask.resume()
    }
}
