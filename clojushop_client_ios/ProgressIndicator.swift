//
//  ProgressIndicator.swift
//  clojushop_client_ios
//
//  Created by ischuetz on 07/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import Foundation

class ProgressIndicator: UIView {
    
    var indicator:UIActivityIndicatorView!
    
    init(frame: CGRect, backgroundColor: UIColor) {
        super.init(frame: frame)
        
        indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        
        indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0)
        indicator.center = self.center
        
        self.addSubview(indicator)
        
        indicator.hidden = false
        indicator.bringSubviewToFront(self)
        indicator.startAnimating()
        self.backgroundColor = backgroundColor
    }
    
    override var hidden:Bool {
        get {
            return super.hidden
        }
        set(hidden) {
            super.hidden = hidden
            let networkIndicatorVisible = hidden ? true : false
            UIApplication.sharedApplication().networkActivityIndicatorVisible = networkIndicatorVisible
        }
    }
}
