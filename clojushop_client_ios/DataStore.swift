//
//  DataStore.swift
//  clojushop_client_ios
//
//  Created by ischuetz on 10/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import Foundation


/**
* Facade for persistent data / global state of the app
* It contains the logic to decide which data source (server, local database, preferences, etc.) to use, caching policy etc.
* Requested data is delivered as domain specific, type safe objects.
*/
@objc
class DataStore {
    
    let dataStoreRemote:DataStoreRemote
    let dataStoreLocal:DataStoreLocal
    
    init() {
        dataStoreRemote = DataStoreRemote()
        dataStoreLocal = DataStoreLocal()
    }

    class func sharedDataStore() -> DataStore {
        return DataStore()
    }
    
    func getProducts(start: Int, size: Int, successHandler: (Product[]) -> (), failureHandler: (Int) -> Bool) {
        var returnedFromCache = false
        
        self.dataStoreLocal.getProducts(start, size: size,
            successHandler: {(productsCD: AnyObject[]) -> () in
                if productsCD.count > 0 {
                    let products:Product[] = Product.createFromCDs(productsCD)
                    successHandler(products)
                    
                    returnedFromCache = true
                }
                
                //background update (silent - new data will be available for the next request)
                self.dataStoreRemote.getProducts(start, size: size,
                    successHandler: {(response: Dictionary<String, NSObject>) -> () in
                        let md5:String = response["md5"] as NSString
                        let productsJSON = response["products"] as NSArray
                        
                        //TODO use md5
                        let products:Product[] = Product.createFromDictArray(productsJSON)
                
                        self.dataStoreLocal.clearProducts()
                        self.dataStoreLocal.saveProducts(products)
                        
                        if !returnedFromCache {
                            successHandler(products)
                        }
                        
                    }, failureHandler: {(statusCode: Int) -> Bool in //failure getting remote data
                        if (!returnedFromCache) {
                            failureHandler(statusCode)
                        }
                        return false //not consumed
                    })

            }, failureHandler: {() -> () in //failure getting data from local cache
            }
        )
    }
    
    func getUser(successHandler: (user: User) -> (), failureHandler: (Int) -> Bool) {
        dataStoreRemote.getUser(
            {(response: Dictionary<String, NSObject>) -> () in
                let userJSON = response["user"] as NSDictionary
                let user:User = User(dict: userJSON)
                successHandler(user: user)},
            failureHandler: {(statusCode: Int) -> Bool in
                failureHandler(statusCode)
            })
    }
    
    func logout(successHandler: () -> (), failureHandler: (Int) -> Bool)  {
        dataStoreRemote.logout(
            {() -> () in
                successHandler()},
            failureHandler: {(statusCode: Int) -> Bool in
                failureHandler(statusCode)
            })
    }
    
    func login(userName: String, password:String, successHandler: () -> (), failureHandler: (Int) -> Bool)  {
        dataStoreRemote.login(userName, password:password,
            successHandler: {() -> () in
                successHandler()},
            failureHandler: {(statusCode: Int) -> Bool in
                failureHandler(statusCode)
            })
    }
    
    func register(userName: String, email:String, password:String, successHandler: () -> (), failureHandler: (Int) -> Bool)  {
        dataStoreRemote.register(userName, email:email, password:password,
            successHandler: {() -> () in
                successHandler()},
            failureHandler: {(statusCode: Int) -> Bool in
                failureHandler(statusCode)
            })
    }
    
    func addToCart(productId: String, successHandler: () -> (), failureHandler: (Int) -> Bool)  {
        dataStoreRemote.addToCart(productId,
            successHandler: {() -> () in
                successHandler()},
            failureHandler: {(statusCode: Int) -> Bool in
                failureHandler(statusCode)
            })
    }
    
    func setCartQuantity(productId: String, quantity: Int, successHandler: () -> (), failureHandler: (Int) -> Bool)  {
        dataStoreRemote.setCartQuantity(productId, quantity: quantity,
            successHandler: {() -> () in
                successHandler()},
            failureHandler: {(statusCode: Int) -> Bool in
                failureHandler(statusCode)
            })
    }
    
    func removeFromCart(productId: String, successHandler: () -> (), failureHandler: (Int) -> Bool)  {
        dataStoreRemote.removeFromCart(productId,
            successHandler: {() -> () in
                successHandler()},
            failureHandler: {(statusCode: Int) -> Bool in
                failureHandler(statusCode)
            })
    }
    
    func getCart(successHandler: (cart: CartItem[]) -> (), failureHandler: (Int) -> Bool)  {
        self.dataStoreRemote.getCart(
            {(response: Dictionary<String, NSObject>) -> () in
                
                let cartJSON = response["cart"] as NSArray
                var cartItems:CartItem[] = CartItem.createFromDictArray(cartJSON)
                
                successHandler(cart: cartItems)
                
            }, failureHandler: {(statusCode: Int) -> Bool in
                failureHandler(statusCode)
            })
    }
    
    func pay(token: String, value: String, currency:String, successHandler: () -> (), failureHandler: (Int) -> Bool)  {
        dataStoreRemote.pay(token, value: value, currency: currency,
            successHandler: {() -> () in
                successHandler()},
            failureHandler: {(statusCode: Int) -> Bool in
                failureHandler(statusCode)
            })
    }

}