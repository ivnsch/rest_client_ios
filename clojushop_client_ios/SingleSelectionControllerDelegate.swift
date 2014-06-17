//
//  SingleSelectionControllerDelegate.swift
//  clojushop_client_ios
//
//  Created by ischuetz on 08/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import Foundation

protocol SingleSelectionControllerDelegate {
    
    func selectedItem(item: SingleSelectionItem, baseObject:AnyObject)
}