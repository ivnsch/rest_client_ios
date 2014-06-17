//
//  Currency.swift
//  clojushop_client_ios
//
//  Created by ischuetz on 06/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import Foundation

@objc
class Currency {
    
    let id:Int, format:String
    
    init(id:Int, format:String) {
        self.id = id
        self.format = format
    }
    
    //workaround for runtime error when calling the contructor from objective c
    class func initHelper(id:Int, format:String) -> Currency {
        
        return Currency(id: id, format: format)
    }
}