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

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        self.tabBarItem.title = "User account"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.setProgressHidden(false)
        
        DataStore.sharedDataStore().getUser(
            
            {(user:User!) -> Void in
                self.setProgressHidden(true)
                
                self.nameField.text = user.name
                self.emailField.text = user.email
//
            }, failureHandler: {(Int) -> Bool in return false})
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
        self.navigationController.popToRootViewControllerAnimated(true)
        self.navigationController.setNavigationBarHidden(false, animated: false) //is this necessary?
        
        self.navigationController.tabBarItem.title = "Login / Register"
    }

    @IBAction func onLogoutPress(sender: UIButton) {
        self.logout()
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
