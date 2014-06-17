//
//  ProductCell.swift
//  clojushop_client_ios
//
//  Created by ischuetz on 06/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import Foundation
import UIKit

@objc
class ProductCell : UITableViewCell {
    
    @IBOutlet var productName:UILabel
    @IBOutlet var productDescr:UILabel
    @IBOutlet var productPrice:UILabel
    @IBOutlet var productBrand:UILabel
    @IBOutlet var productImg:UIImageView
}