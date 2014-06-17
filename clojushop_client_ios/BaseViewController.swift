//
//  BaseViewController.swift
//  clojushop_client_ios
//
//  Created by ischuetz on 07/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import Foundation

class BaseViewController: UIViewController {
    var opaqueIndicator: ProgressIndicator!
    var transparentIndicator: ProgressIndicator!
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    func getProgressBarBounds() -> CGRect {
        var bounds:CGRect = UIScreen.mainScreen().bounds
        
        let viewSize = self.tabBarController.view.frame.size
        let tabBarSize = self.tabBarController.tabBar.frame.size
        
        bounds.size.height = viewSize.height - tabBarSize.height
        
        return bounds
    }
    
    func initProgressIndicator() {
        self.opaqueIndicator = ProgressIndicator(frame: getProgressBarBounds(), backgroundColor: UIColor.whiteColor())
        self.transparentIndicator = ProgressIndicator(frame: getProgressBarBounds(), backgroundColor: UIColor.clearColor())
        
        self.view.addSubview(opaqueIndicator)
        self.view.addSubview(transparentIndicator)
        
        self.setProgressHidden(true, transparent: true)
        self.setProgressHidden(true, transparent: false)
    }
    
    override func viewDidLoad() {
        self.initProgressIndicator()
    }
    
    override func shouldAutorotate() -> Bool {
        return true //iOS 5- compatibility
    }
    
    override func viewWillUnload() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func setProgressHidden(hidden: Bool, transparent: Bool) {
        let indicator = transparent ? transparentIndicator : opaqueIndicator
        indicator.hidden = hidden
    }
    
    func setProgressHidden(hidden: Bool) {
        self.setProgressHidden(hidden, transparent: false)
    }
}