//
//  UserAccountViewController.swift
//  clojushop_client_ios
//
//  Created by ischuetz on 08/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import UIKit

class UserAccountViewController: BaseViewController {
    
    @IBOutlet var nameField:UILabel!
    @IBOutlet var emailField:UILabel!

    var user:User!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        self.tabBarItem.title = "User account"
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        self.setProgressHidden(false)

    }
    
    func initUserViews() {
        self.nameField.text = user.name
        self.emailField.text = user.email
        
        self.setProgressHidden(true)
    }
    
    func getUser() {
        
        DataStore.sharedDataStore().getUser(
            
            {(user:User!) -> Void in
                
                self.user = user
                
                self.initUserViews()
                
            }, failureHandler: {(Int) -> Bool in return false})
    }
    
    
    override func viewDidAppear(animated: Bool) {
        if user == nil {
            getUser()
        } else {
            self.initUserViews()
        }
    }
    
    func logout() {
//        self.setProgressHidden(false)

        DataStore.sharedDataStore().logout(
            {() -> Void in
//                self.setProgressHidden(true)
                self.replaceWithLoginRegisterTab()
            
            }, failureHandler: {(Int) -> Bool in return false})
    }
    
    
    func replaceWithLoginRegisterTab() {
        self.navigationController?.popToRootViewControllerAnimated(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false) //is this necessary?
        
        self.navigationController?.tabBarItem.title = "Login / Register"
    }

    @IBAction func onLogoutPress(sender: UIButton) {
        self.logout()
    }
}
