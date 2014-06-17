//
//  ProductListViewController.swift
//  clojushop_client_ios
//
//  Created by ischuetz on 07/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import Foundation

class ProductListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    var products:Product[] = []
    
    @IBOutlet var tableView:UITableView!
    
    var detailsViewController:ProductDetailViewController!
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "Clojushop client"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let productCellNib:UINib = UINib(nibName: "CSProductCell", bundle: nil)
        tableView.registerNib(productCellNib, forCellReuseIdentifier: "CSProductCell")
        self.requestProducts()
    }

    func requestProducts() {
        self.setProgressHidden(false)
        
        DataStore.sharedDataStore().getProducts(0, size: 4, successHandler:
            
            {(products:Product[]!) -> Void in
                self.setProgressHidden(true)
                self.onRetrievedProducts(products)
                },
            failureHandler: {(Int) -> Bool in return false})
    }
    
    func onRetrievedProducts(products:Product[]) {
        self.products = products
        tableView.reloadData()
    }

    func tableView(tableView:UITableView, numberOfRowsInSection section:NSInteger) -> Int {
        return products.count
    }


    func tableView(tableView:UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        
        let product = products[indexPath.row]
        
        if !self.splitViewController {
            let detailsViewController:ProductDetailViewController = ProductDetailViewController(nibName: "CSProductDetailsViewController", bundle: nil)
            
            detailsViewController.product = product
            detailsViewController.listViewController(product)
            navigationController.pushViewController(detailsViewController, animated: true)
        } else {
            detailsViewController.listViewController(product)
        }
    }
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell! {
        let cellIdentifier:String = "CSProductCell"
        let cell:ProductCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as ProductCell
        
        let product:Product = products[indexPath.row]
        
        cell.productName.text = product.name
        cell.productDescr.text = product.descr
        cell.productBrand.text = product.seller
        
        cell.productPrice.text = CurrencyManager.sharedCurrencyManager().getFormattedPrice(product.price, currencyId: product.currency)
        
        cell.productImg.setImageWithURL(NSURL.URLWithString(product.imgList))
        
        return cell
    }
    
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> Double {
        return 133
    }
    
    func transferBarButtonToViewController(vc:UIViewController) {
        let nvc:UINavigationController = self.splitViewController.viewControllers[0] as UINavigationController
        let currentVC:UIViewController = nvc.viewControllers[0] as UIViewController
        
        if vc == currentVC {return}
        
        let currentVCItem:UINavigationItem = currentVC.navigationItem
        
        vc.navigationItem.setLeftBarButtonItem(currentVCItem.leftBarButtonItem, animated: true)
        
        currentVCItem.setLeftBarButtonItem(nil, animated: false)
    }
    
}






