//
//  SingleSelectionControllerDelegate.swift
//  clojushop_client_ios
//
//  Created by ischuetz on 08/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import Foundation

protocol SingleSelectionControllerDelegate {
    
    //Generics + protocols in our generic Dialog use case, seems not to work. So we have to revert to AnyObject and casting
//    typealias BaseObjectType
    
//    func selectedItem(item: SingleSelectionItem, baseObject:BaseObjectType)
    func selectedItem(item: SingleSelectionItem, baseObject:AnyObject)
}