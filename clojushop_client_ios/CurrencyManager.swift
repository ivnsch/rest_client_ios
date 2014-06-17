//
//  CurrencyManager.swift
//  clojushop_client_ios
//
//  Created by ischuetz on 09/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import Foundation

class CurrencyManager {

    var currencyMap:Dictionary<String, Currency> = Dictionary<String, Currency>()
    
    //class variables not yet supported... no singleton possible
    //class let currencyManager:CurrencyManager
    
    init() {
        //for now this is in the client. At some point server can send it to us in e.g. an initialisation block.
        currencyMap["1"] = Currency(id: 1, format: "%@ €")
        currencyMap["2"] = Currency(id: 2, format: "$ %@")
    }
    
    class func sharedCurrencyManager() -> CurrencyManager {
        return CurrencyManager() //for now return a new instance
    }
    
    func getFormattedPrice(price: String, currencyId: String) -> String {
        let currencyFormat = currencyMap[currencyId]!.format
        return String(format: currencyFormat, price)
    }
}