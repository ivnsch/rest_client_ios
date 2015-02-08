//
//  CartItem.swift
//  clojushop_client_ios
//
//  Created by ischuetz on 06/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import Foundation



let JSON_KEY_CART_ITEM_ID = "id"
let JSON_KEY_CART_ITEM_NAME = "na"
let JSON_KEY_CART_IMAGE = "pic"
let JSON_KEY_CART_ITEM_DESCRIPTION = "des"
let JSON_KEY_CART_ITEM_PRICE = "pr"
let JSON_KEY_CART_ITEM_PRICE_VALUE = "v"
let JSON_KEY_CART_ITEM_PRICE_CURRENCY = "c"
let JSON_KEY_CART_ITEM_SELLER = "se"
let JSON_KEY_CART_ITEM_QUANTITY = "qt"
let JSON_KEY_CART_LIST = "pl"
let JSON_KEY_CART_DETAILS = "pd"

@objc
class CartItem {
    
    let id:String!, name:String!, descr:String!, seller:String!, price:Double!, currency:String!, imgList:String!, imgDetails:String!
    var quantity:Int!
    
    init(id:String, name:String, descr:String, seller:String, price:Double, currency:String, quantity:Int, imgList:String, imgDetails:String) {
        
        self.id = id
        self.name = name
        self.descr = descr
        self.seller = seller
        self.price = price
        self.quantity = quantity
        self.currency = currency
        self.imgList = imgList
        self.imgDetails = imgDetails
    }

    convenience init(dict: NSDictionary) {
        
        let priceDictionary: NSDictionary = dict.objectForKey(JSON_KEY_CART_ITEM_PRICE) as NSDictionary
        let imgDictionary: NSDictionary = dict.objectForKey(JSON_KEY_CART_IMAGE) as NSDictionary
    
        let priceNSStr = priceDictionary.objectForKey(JSON_KEY_CART_ITEM_PRICE_VALUE) as NSString
        let priceDouble:Double = (priceNSStr).doubleValue
        
        self.init(
            id: dict.objectForKey(JSON_KEY_CART_ITEM_ID) as NSString as String,
            name: dict.objectForKey(JSON_KEY_CART_ITEM_NAME) as NSString as String,
            descr: dict.objectForKey(JSON_KEY_DESCRIPTION) as NSString as String,
            seller: dict.objectForKey(JSON_KEY_SELLER) as NSString as String,
            price: priceDouble,
            currency: priceDictionary.objectForKey(JSON_KEY_CART_ITEM_PRICE_CURRENCY) as NSString as String,
            quantity: (dict.objectForKey(JSON_KEY_CART_ITEM_QUANTITY) as NSNumber).integerValue,
            imgList: imgDictionary.objectForKey(JSON_KEY_CART_LIST) as NSString as String,
            imgDetails: imgDictionary.objectForKey(JSON_KEY_CART_DETAILS) as NSString as String
        )
    }
    
    //workaround for runtime error when calling the contructor from objective c
    class func initWithDictHelper(dict: NSDictionary) -> CartItem {
        return CartItem(dict: dict)
    }
    
    class func createFromDictArray (dictArray: NSArray) -> Array<CartItem> {
        var itemsArray:[CartItem] = []
        
        for dict: AnyObject in dictArray {
            let a:NSDictionary = dict as NSDictionary
            itemsArray.append(CartItem(dict: a))
        }
        return itemsArray
    }
}