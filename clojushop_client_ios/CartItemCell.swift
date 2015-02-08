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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func onQuantityPress(sender: UIButton) {
        if let indexPath = self.tableView.indexPathForCell(self) {
            controller.setQuantity(sender, atIndexPath: indexPath) //FIXME
        }
    }
}