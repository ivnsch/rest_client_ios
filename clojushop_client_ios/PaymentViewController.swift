//
//  PaymentViewController.swift
//  clojushop_client_ios
//
//  Created by ischuetz on 17/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import Foundation

let EXAMPLE_STRIPE_PUBLISHABLE_KEY = "pk_test_6pRNASCoBOKtIshFeQd4XMUh"


class PaymentViewController : UIViewController, STPViewDelegate {
    
    var checkoutView:STPView!
    var currency:Currency!
    var totalValue:Double!
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Cart"
        if self.respondsToSelector("setEdgesForExtendedLayout") { //TODO is this check necessary?
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        let saveButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Done, target: self, action: "save:")
        saveButton.enabled = true
        self.navigationItem.rightBarButtonItem = saveButton
        
        self.checkoutView = STPView(frame: CGRectMake(15, 20, 290, 55), andKey: "pk_test_6pRNASCoBOKtIshFeQd4XMUh")
        self.checkoutView.delegate = self
        self.view.addSubview(self.checkoutView)
    }
    
    func stripeView(view:STPView, card:PKCard, isValid:Bool) {
        self.navigationItem.rightBarButtonItem.enabled = isValid
    }
    
    @IBAction func save(sender: AnyObject) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        self.checkoutView.createToken({(token:STPToken!, error:NSError!) -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            
            if error {
                self.hasError(error)
            } else {
                self.hasToken(token)
            }
        })
    }
    
    func hasError(error: NSError) {
        DialogUtils.showAlert("Error", msg:error.localizedDescription)
    }
    
    func hasToken(token: STPToken) {
        
        DataStore.sharedDataStore().pay(token.tokenId, value: String(totalValue), currency: "eur", successHandler: {() -> Void in
            
            NSNotificationCenter.defaultCenter().postNotificationName("ClearLocalCart", object: nil)
            
            self.navigationController.popViewControllerAnimated(true)
            
            }, failureHandler: {(Int) -> Bool in
                
                DialogUtils.showAlert("Error", msg: "Error ocurred processing payment")
                return false})
    }
    
    
    
}
