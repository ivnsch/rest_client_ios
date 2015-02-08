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
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getProgressBarBounds() -> CGRect {
        var bounds:CGRect = UIScreen.mainScreen().bounds
        
        if let tabBarController = self.tabBarController {
            let viewSize = tabBarController.view.frame.size
            let tabBarSize = tabBarController.tabBar.frame.size
            
            bounds.size.height = viewSize.height - tabBarSize.height
            
            return bounds
            
        } else {
            return CGRectZero
        }
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
    
    deinit {
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