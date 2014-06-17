//
//  CartQuantityItem.swift
//  clojushop_client_ios
//
//  Created by ischuetz on 08/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import Foundation

class CartQuantityItem: SingleSelectionItem {
    
    let quantity:Int
    
    init(quantity:Int) {
        self.quantity = quantity
    }
    
    func getLabel() -> String {
        return String(self.quantity)
    }
    
    func getWrappedItem() -> AnyObject {
        return quantity
    }
}