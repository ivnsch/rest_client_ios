//
//  ProductDetailViewController.swift
//  clojushop_client_ios
//
//  Created by ischuetz on 07/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import Foundation

class ProductDetailViewController: BaseViewController, ListViewControllerDelegate, UISplitViewControllerDelegate {
        
    @IBOutlet var productNameLabel:UILabel
    @IBOutlet var productBrandLabel:UILabel
    @IBOutlet var productPriceLabel:UILabel
    @IBOutlet var productLongDescrLabel:UILabel
    
    @IBOutlet var productImageview:UIImageView
    
    @IBOutlet var addToCartButton:UIButton
    
    @IBOutlet var pleaseSelectView:UIView
    @IBOutlet var containerView:UIView
    
    var product:Product!
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!)  {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    func listViewController(
//        lvc: ProductsListViewController,
        product: Product) {
        self.product = product
        
        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad) {
            self.initViews()
        }
    }
    
    func splitViewController(svc: UISplitViewController!, willHideViewController aViewController: UIViewController!, withBarButtonItem barButtonItem: UIBarButtonItem!, forPopoverController pc: UIPopoverController!) {
        barButtonItem.title = "List"
        self.navigationItem.setLeftBarButtonItem(barButtonItem, animated: true)
    }
    
    func initViews() {
        pleaseSelectView.hidden = true
        
        self.title = product.name
        
        productNameLabel.text = product.name
        productBrandLabel.text = product.seller
        productPriceLabel.text = product.price
        
        productLongDescrLabel.text = product.descr
        productImageview.setImageWithURL(NSURL.URLWithString(product.imgDetails))
    }
    
    func splitViewController(svc: UISplitViewController!, aViewController: UIViewController!, button: UIBarButtonItem!) {
    
        if button == self.navigationItem.leftBarButtonItem {
            self.navigationItem.setLeftBarButtonItem(nil, animated: true)
        }
    }
    
    func showMaster() {
        //TODO (master visible on iPad, the first time)
//        [self.navigationItem.leftBarButtonItem.target performSelector:self.navigationItem.leftBarButtonItem.action withObject:self.navigationItem];
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if UIInterfaceOrientation.Portrait == self.interfaceOrientation || UIInterfaceOrientation.PortraitUpsideDown == self.interfaceOrientation {
            showMaster()
        }
            
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            self.initViews() //in phone we passed the product before launching the controller
        } else {
            pleaseSelectView.hidden = false //in ipad at start this controller is visible, and no product selected yet
        }
    }
    
    @IBAction func onAddToCartPress(sender : UIButton) {
        DataStore.sharedDataStore().addToCart(product.id, successHandler: {() -> Void in
            DialogUtils.showAlert("Success", msg: "Added!")
            
            }, failureHandler: {(Int) -> Bool in return false})
    }
}