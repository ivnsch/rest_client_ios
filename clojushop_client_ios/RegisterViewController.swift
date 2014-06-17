//
//  RegisterViewController.swift
//  clojushop_client_ios
//
//  Created by ischuetz on 08/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {

    @IBOutlet var loginNameField:UITextField!
    @IBOutlet var emailField:UITextField!
    @IBOutlet var loginPWField:UITextField!
    
//    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
    
    func fillWithTestData() {
        loginNameField.text = "user1"
        emailField.text = "user2@bla.com"
        loginPWField.text = "test123"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillWithTestData()

        //FIXME nothing works - tap listener not called. Probably because the root view outlet is cant be attached?
        let tap:UIGestureRecognizer = UIGestureRecognizer(target: self, action: "dismissKeyboard:")
        self.view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        loginNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        loginPWField.resignFirstResponder()
    }
    
    @IBAction func onRegisterPress(sender : UIButton) {
        let loginName:String = loginNameField.text
        let email:String = emailField.text
        let loginPW:String = loginPWField.text
        
        self.setProgressHidden(false)
        
        DataStore.sharedDataStore().register(loginName, email: email, password: loginPW, successHandler: {() -> Void in
            
            self.setProgressHidden(true)
            self.navigationController.popToRootViewControllerAnimated(true)
            
            }, failureHandler: {(Int) -> Bool in self.setProgressHidden(true); return false})
    }

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
