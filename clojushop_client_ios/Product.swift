//
//  Product.swift
//  clojushop_client_ios
//
//  Created by ischuetz on 05/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import Foundation

//For now let the constants here, since class variables are not supported yet
let JSON_KEY_ID = "id"
let JSON_KEY_NAME = "na"
let JSON_KEY_IMAGE = "img"
let JSON_KEY_DESCRIPTION = "des"
let JSON_KEY_PRICE = "pr"
let JSON_KEY_PRICE_VALUE = "v"
let JSON_KEY_PRICE_CURRENCY = "c"
let JSON_KEY_SELLER = "se"
let JSON_KEY_LIST = "pl"
let JSON_KEY_DETAILS = "pd"

@objc
class Product {
    
    let id:String, name:String, descr:String, seller:String, price:String, currency:String, imgList:String, imgDetails:String
    
    init(id:String, name:String, descr:String, seller:String, price:String, currency:String, imgList:String, imgDetails:String) {

        self.id = id
        self.name = name
        self.descr = descr
        self.seller = seller
        self.price = price
        
        self.currency = currency
        self.imgList = imgList
        self.imgDetails = imgDetails
    }

    convenience init(dict: NSDictionary) {
        
        let priceDictionary: NSDictionary = dict.objectForKey(JSON_KEY_PRICE) as NSDictionary
        let imgDictionary: NSDictionary = dict.objectForKey(JSON_KEY_IMAGE) as NSDictionary
        
        self.init(
            id: dict.objectForKey(JSON_KEY_ID) as NSString as String,
            name: dict.objectForKey(JSON_KEY_NAME) as NSString as String,
            descr: dict.objectForKey(JSON_KEY_DESCRIPTION) as NSString as String,
            seller: dict.objectForKey(JSON_KEY_SELLER) as NSString as String,
            price: priceDictionary.objectForKey(JSON_KEY_PRICE_VALUE) as NSString as String,
            currency: priceDictionary.objectForKey(JSON_KEY_PRICE_CURRENCY) as NSString as String,
            imgList: imgDictionary.objectForKey(JSON_KEY_LIST) as NSString as String,
            imgDetails: imgDictionary.objectForKey(JSON_KEY_DETAILS) as NSString as String
        )
    }
    
    
    class func createFromCD (productCD: ProductCD) -> Product {
        let product = Product(
            id: productCD.id,
            name: productCD.name,
            descr: productCD.descr,
            seller:productCD.seller,
            price: productCD.price,
            currency: productCD.currency,
            imgList: productCD.img_pl,
            imgDetails: productCD.img_pd
        )
        
        return product
    }
    
    class func createFromDictArray (dictArray: NSArray) -> Array<Product> {
        var productsArray:Product[] = []
        
        for dict: AnyObject in dictArray {
            productsArray += Product(dict: dict as NSDictionary)
        }
        return productsArray
    }
    
    class func createFromCDs (productCDs: NSArray) -> Array<Product> {
        var productsArray:Product[] = []
        
        for productCD: AnyObject in productCDs {
            productsArray += self.createFromCD(productCD as ProductCD)
        }
        return productsArray
    }
}