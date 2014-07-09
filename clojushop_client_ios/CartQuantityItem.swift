//
//  CartQuantityItem.swift
//  clojushop_client_ios
//
//  Created by ischuetz on 08/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import Foundation

class CartQuantityItem: SingleSelectionItem {
    
    //For some reason type alias here doesn't work (see SingleSelectionItem and CartViewController)
    //when we use generics the caller will say getWrappedItem() doesn't exist  FIXME?
    //also tried removing typealias definition here, since it doesn't seen to be necessary, no effect
//    typealias WrappedItemType = Int

    let quantity:Int
    
    init(quantity:Int) {
        self.quantity = quantity
    }
    
    func getLabel() -> String {
        return String(self.quantity)
    }
    
//    func getWrappedItem() -> Int {
    func getWrappedItem() -> AnyObject {
        return quantity
    }
}