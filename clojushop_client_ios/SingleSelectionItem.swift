//
//  SingleSelectionItem.swift
//  clojushop_client_ios
//
//  Created by ischuetz on 08/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import Foundation


protocol SingleSelectionItem {
    
    //For some reason type alias here doesn't work (see CartQuantityItem and CartViewController)
    //when we use generics the caller will say getWrappedItem() doesn't exist  FIXME?
//    typealias WrappedItemType

    func getLabel() -> String
    
//    func getWrappedItem() -> WrappedItemType
    func getWrappedItem() -> AnyObject
}

