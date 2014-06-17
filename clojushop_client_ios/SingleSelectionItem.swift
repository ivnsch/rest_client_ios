//
//  SingleSelectionItem.swift
//  clojushop_client_ios
//
//  Created by ischuetz on 08/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import Foundation


protocol SingleSelectionItem {
    
//    typealias WrappedItemType //TODO

    func getLabel() -> String
    
//    func getWrappedItem() -> WrappedItemType
    func getWrappedItem() -> AnyObject
}

