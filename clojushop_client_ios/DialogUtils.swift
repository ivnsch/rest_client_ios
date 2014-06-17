//
//  DialogUtils.swift
//  clojushop_client_ios
//
//  Created by ischuetz on 09/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import Foundation

@objc
class DialogUtils {
    
    class func showAlert(/*viewController: UIViewController, */title:String, msg:String) {
        
        //This is not only "deprecated", it also crashes the app on new OS
//        let alert:UIAlertView = UIAlertView(title: title, message: msg, delegate: nil, cancelButtonTitle: "Ok")
//        alert.show()
        
        let alert = UIAlertView()
        alert.title = title
        alert.message = msg
        alert.addButtonWithTitle("Ok")
        alert.show()
        
        //for this we need the view controller, but currently this is  used in classes that don't have a view controller reference
//        var alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
//        viewController.presentViewController(alert, animated: true, completion: nil)
    }
}