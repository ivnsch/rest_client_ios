//
//  LoginViewController.swift
//  clojushop_client_ios
//
//  Created by ischuetz on 07/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import Foundation

class LoginRegisterViewController:BaseViewController {
    
    @IBOutlet var loginNameField:UITextField!
    @IBOutlet var loginPWField:UITextField!
    
    @IBOutlet var viewWorkaround:UIView! //FIXME workaround didnt work
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!)  {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.tabBarItem.title = "Login / Register"
    }
    
    func fillWithTestData() {
        loginNameField.text = "user1"
        loginPWField.text = "test123"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fillWithTestData()

        //FIXME nothing works - tap listener not called. Probably because the root view outlet is cant be attached?
//        let tap:UIGestureRecognizer = UIGestureRecognizer(target: self, action: "dismissKeyboard:")
        let tap:UIGestureRecognizer = UIGestureRecognizer(target: viewWorkaround, action: "dismissKeyboard:")
        self.view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        loginNameField.resignFirstResponder()
        loginPWField.resignFirstResponder()
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.setProgressHidden(true) //clear possible progressbar we started last time showing user account. Do it here instad immediately after to avoid flickering on transition
    }
    
    func getUser() {
        
        DataStore.sharedDataStore().getUser(
            
            {(user:User!) -> Void in
                self.showUserAccountTab(user)
                
            }, failureHandler: {(Int) -> Bool in return false})
    }
    
    @IBAction func login(sender: UIButton) {
        let loginName:String = loginNameField.text
        let loginPW:String = loginPWField.text

        self.setProgressHidden(false)
        
        DataStore.sharedDataStore().login(loginName, password: loginPW, successHandler: {() -> Void in

            self.getUser()
            
            }, failureHandler: {(Int) -> Bool in
                return false})
    }
    @IBAction func register(sender: UIButton) {
        let registerController:RegisterViewController = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
        self.navigationController.pushViewController(registerController, animated: true)
    }
        
    func showUserAccountTab(user:User) {
        let userAccountController: UserAccountViewController = UserAccountViewController(nibName: "UserAccountViewController", bundle: nil)
        userAccountController.user = user
        self.navigationController.tabBarItem.title = "User account"
        self.navigationController.pushViewController(userAccountController, animated: true)
        self.navigationController.navigationBarHidden = true
    }
    
    
}