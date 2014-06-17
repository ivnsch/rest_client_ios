//
//  CartItemCell.swift
//  clojushop_client_ios
//
//  Created by ischuetz on 08/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import Foundation

class CartItemCell : UITableViewCell {
    
    var controller:CartViewController!
    var tableView:UITableView!
    
    @IBOutlet var itemImage:UIImageView!
    @IBOutlet var productName:UILabel!
    @IBOutlet var productDescr:UILabel!
    @IBOutlet var productBrand:UILabel!
    @IBOutlet var productPrice:UILabel!
    @IBOutlet var productImg:UIImageView!
    @IBOutlet var quantityField:UILabel!
    
    init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    @IBAction func onQuantityPress(sender: UIButton) {
        let indexPath = self.tableView.indexPathForCell(self)
        controller.setQuantity(sender, atIndexPath: indexPath) //FIXME
    }
}