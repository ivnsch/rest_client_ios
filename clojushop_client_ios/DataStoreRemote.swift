//
//  DataStoreRemote.swift
//  clojushop_client_ios
//
//  Created by ischuetz on 09/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import Foundation

/**
* This class bundles parameters with server specific keys, executes a request, and returns the (complete, e.g. including md5) response in form of a dictionary.
* It also does error handling depending on the response's status code, with optional delegation to the caller
* TODO move error handling (showing of alert) to BaseViewController
*/
class DataStoreRemote {
    
    let host:String
    
    class func sharedDataStoreRemote() -> DataStoreRemote {
        return DataStoreRemote() //for now just create a new instance, class variables not supported yet
    }
    
    init() {
        let path = NSBundle.mainBundle().pathForResource("Config", ofType: "plist")
        let config:NSDictionary = NSDictionary(contentsOfFile:path)
        
        host = config.objectForKey("host") as String
    }
    
    /**
    * Map server to client status codes
    */
    func toClientStatusCode(serverStatusCode: Int) -> Int {
        return serverStatusCode //for now we return the same status code
    }
    
    
    func request(method:Int, url:String, params:Dictionary<String, AnyObject>, requestSuccessHandler: (Dictionary<String, NSObject>) -> (), requestFailureHandler: (Int) -> Bool) {
        
        /**
        * Give caller opportunity to handle the failure.
        * If caller returns true ("consumed"), the error is not being further handled
        * If caller returns false ("not consumed"), the default handling will be activated
        */
        func localFailureHandler(statusCode:Int) {
            let localStatusCode = toClientStatusCode(statusCode)
            let consumed = requestFailureHandler(localStatusCode)
            if !consumed {
                self.onRequestError(localStatusCode)
            }
        }
        
        let manager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        

        println("Request method: " + method.description + ", url: " + url + ", params: " + params.description)

        //TODO handle possible error response with html e.g. not found page
        
        //FIXME getting weird error messages when use NSDictionary or Dictionary<String, NSObject> as type of response
        let successHandler = {(operation: AFHTTPRequestOperation!, response: AnyObject!) -> () in

            println("Request response: " + response.description)

            let responseDict = response as Dictionary<String, NSObject>
            
            let statusCode:Int =  (responseDict["status"] as NSNumber).integerValue

            if statusCode == 1 {
                requestSuccessHandler(responseDict)

            } else {
                localFailureHandler(statusCode)
            }
        }
        
        let failureHandler = {(operation: AFHTTPRequestOperation!, error: NSError!) -> () in
            
            println("Request error: " + error.description)

            let statusCode:Int =  9
            localFailureHandler(statusCode)
        }
        
        if (method == 1) {
            manager.GET(url, parameters: params, success: successHandler, failure: failureHandler)
        } else if (method == 2) {
            manager.POST(url, parameters: params, success: successHandler, failure: failureHandler)
        } else {

        }
    }
    
    func get(url:String, params:Dictionary<String, AnyObject>, requestSuccessHandler: (Dictionary<String, NSObject>) -> (), requestFailureHandler: (Int) -> Bool) {
        self.request(1, url: url, params: params, requestSuccessHandler: requestSuccessHandler, requestFailureHandler: requestFailureHandler)
    }
    
    func post(url:String, params:Dictionary<String, AnyObject>, requestSuccessHandler: (Dictionary<String, NSObject>) -> (), requestFailureHandler: (Int) -> Bool) {
        self.request(2, url: url, params: params, requestSuccessHandler: requestSuccessHandler, requestFailureHandler: requestFailureHandler)
    }
    
    func onRequestError(statusCode:Int) {
        var errorMsg = ""
        
        switch(statusCode) {
            case 0, 2, 9 /* 9 is a local error -> wrong json format (TODO?) */:
                errorMsg = "An unknown error ocurred. Please try again later."
            case 4:
                errorMsg = "Not found."
            case 5:
                errorMsg = "Validation error."
            case 3:
                errorMsg = "User already exists."
            case 6:
                errorMsg = "Login failed, check your data is correct."
            case 7:
                errorMsg = "Not authenticated, please register/login and try again."
            case 8:
                errorMsg = "Connection error."
            default:
                break;
        }
        
        
        //TODO return error object to the view controller instead of showing directly alert,
        //BaseViewController will handle it and show the alert
        //Then we can pass a UIViewController to DialogUtils and use UIAlertController
        DialogUtils.showAlert("Error", msg: errorMsg)
    }
    
    func addScreenSize(params:Dictionary<String, AnyObject>) -> Dictionary<String, AnyObject> {
        
        var paramsMutableCopy = params //this will create a mutable copy. We prefer this than inout parameter because it's cleaner fp
        
        let bounds:CGRect = UIScreen.mainScreen().bounds
        
        let w = Int(bounds.width)
        let h = Int(bounds.height)
        let str:String = w.description + "x" + h.description
        
        paramsMutableCopy["scsz"] = str
        return paramsMutableCopy
    }
    
    func getProducts(start: Int, size: Int, successHandler: (Dictionary<String, NSObject>) -> (), failureHandler: (Int) -> Bool) {
        let url:String = host + "/products"
        var params: Dictionary<String, AnyObject> = ["st": String(start), "sz": String(size)]
        params = self.addScreenSize(params)
        
        self.get(url, params: params,
            requestSuccessHandler: {(response: Dictionary<String, NSObject>) -> () in
                
                successHandler(response)
                
            },
            requestFailureHandler: {(statusCode: Int) -> Bool in
                failureHandler(statusCode)
            }
        )
    }
    
    func getUser(successHandler: (Dictionary<String, NSObject>) -> (), failureHandler: (Int) -> Bool) {
        let url:String = host + "/user"
        
        var params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()

        self.get(url, params: params,
            requestSuccessHandler: {(response: Dictionary<String, NSObject>) -> () in

                successHandler(response)
                
            },
            requestFailureHandler: {(statusCode: Int) -> Bool in
                failureHandler(statusCode)
            }
        )
    }
    
    func logout(successHandler: () -> (), failureHandler: (Int) -> Bool)  {
        let url:String = host + "/user/logout"

        self.get(url, params: Dictionary<String, AnyObject>(),
            requestSuccessHandler: {(response: Dictionary<String, NSObject>) -> () in
                successHandler()
            },
            requestFailureHandler: {(statusCode: Int) -> Bool in
                failureHandler(statusCode)
            }
        )
    }
    
    func login(userName: String, password:String, successHandler: () -> (), failureHandler: (Int) -> Bool)  {
        let url:String = host + "/user/login"
        
        var params: Dictionary<String, AnyObject> = [
            "una": userName,
            "upw": password]
        
        self.post(url, params: params,
            requestSuccessHandler: {(response: Dictionary<String, NSObject>) -> () in
                successHandler()
            },
            requestFailureHandler: {(statusCode: Int) -> Bool in
                failureHandler(statusCode)
            }
        )
    }
    
    func register(userName: String, email:String, password:String, successHandler: () -> (), failureHandler: (Int) -> Bool)  {
        let url:String = host + "/user/register"
    
        var params: Dictionary<String, AnyObject> = [
            "una": userName,
            "uem": email,
            "upw": password]

        self.post(url, params: params,
            requestSuccessHandler: {(response: Dictionary<String, NSObject>) -> () in
                successHandler()
            },
            requestFailureHandler: {(statusCode: Int) -> Bool in
                failureHandler(statusCode)
            }
        )
    }

    func addToCart(productId: String, successHandler: () -> (), failureHandler: (Int) -> Bool)  {
        let url:String = host + "/cart/add"
    
        var params: Dictionary<String, AnyObject> = [
            "pid": productId
        ]
    
        self.post(url, params: params,
            requestSuccessHandler: {(response: Dictionary<String, NSObject>) -> () in
                successHandler()
            },
            requestFailureHandler: {(statusCode: Int) -> Bool in
                failureHandler(statusCode)
            }
        )
    }

    func setCartQuantity(productId: String, quantity: Int, successHandler: () -> (), failureHandler: (Int) -> Bool)  {
        let url:String = host + "/cart/quantity"
        
        var params: Dictionary<String, AnyObject> = [
            "pid": productId,
            "qt": quantity
        ]
        
        self.post(url, params: params,
            requestSuccessHandler: {(response: Dictionary<String, NSObject>) -> () in
                successHandler()
            },
            requestFailureHandler: {(statusCode: Int) -> Bool in
                failureHandler(statusCode)
            }
        )
    }

    func removeFromCart(productId: String, successHandler: () -> (), failureHandler: (Int) -> Bool)  {
        let url:String = host + "/cart/remove"
        
        var params: Dictionary<String, AnyObject> = [
            "pid": productId
        ]
        
        self.post(url, params: params,
            requestSuccessHandler: {(response: Dictionary<String, NSObject>) -> () in
                successHandler()
            },
            requestFailureHandler: {(statusCode: Int) -> Bool in
                failureHandler(statusCode)
            }
        )
    }
    
    //TODO pass caller array not nsarray
    func getCart(successHandler: (Dictionary<String, NSObject>) -> (), failureHandler: (Int) -> Bool)  {
        let url:String = host + "/cart"
        
        var params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        params = self.addScreenSize(params)
        
        self.get(url, params: params,
            requestSuccessHandler: {(response: Dictionary<String, NSObject>) -> () in
                
                successHandler(response)
            },
            requestFailureHandler: {(statusCode: Int) -> Bool in
                failureHandler(statusCode)
            }
        )
    }

    func pay(token: String, value: String, currency:String, successHandler: () -> (), failureHandler: (Int) -> Bool)  {
        let url:String = host + "/pay"
        
        var params: Dictionary<String, AnyObject> = [
            "to": token,
            "v": value,
            "c": currency
        ]
        
        self.post(url, params: params,
            requestSuccessHandler: {(response: Dictionary<String, NSObject>) -> () in
                successHandler()
            },
            requestFailureHandler: {(statusCode: Int) -> Bool in
                failureHandler(statusCode)
            }
        )
    }
}