//
//  ProductCD.swift
//  clojushop_client_ios
//
//  Created by ischuetz on 07/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import Foundation
import CoreData

class ProductCD : NSManagedObject {

    @NSManaged var id:String, name:String, img_pl:String, descr:String, price:String, currency:String, seller:String, img_pd:String,
    ordering:CDouble //Double, Int, Integer, CInt, NSNumber, NSInteger, passing as NSNumber, NSInteger, etc. nothing works!!
}