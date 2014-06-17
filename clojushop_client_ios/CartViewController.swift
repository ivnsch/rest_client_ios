//
//  CartViewController.swift
//  clojushop_client_ios
//
//  Created by ischuetz on 08/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import Foundation

class CartViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, SingleSelectionControllerDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var emptyCartView: UIView!
    
    @IBOutlet var totalContainer: UIView!
    @IBOutlet var buyView: UIView!
    @IBOutlet var totalView: UILabel!
    
    var quantityPicker: SingleSelectionViewController!
    var quantityPickerPopover: UIPopoverController!
    
    var items: CartItem[] = []
    var showingController: Bool! = false //quickfix to avoid reloading when coming back from quantity controller... needs correct implementation
    var currency: Currency!
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.tabBarItem.title = "Cart"
    }
    
    func clearCart() {
        self.items.removeAll(keepCapacity: false)
        self.tableView.reloadData()
        
        
        var a : String[] = []
        a.removeAll(keepCapacity: false)
    }
    
    func onRetrievedItems(items: CartItem[]) {
        self.items = items
        
        if (items.count == 0) {
            self.showCartState(true)
        } else {
            self.showCartState(false)
            self.tableView.reloadData()
            self.onModifyLocalCartContent()
        }
    }
    
    func showCartState(empty: Bool) {
        emptyCartView.hidden = !empty
    }
    
    func onModifyLocalCartContent() {
        if (items.count == 0) {
            totalView.text = "0" //just for consistency
            
            self.showCartState(true)
            
        } else {
            //TODO server calculates this
            //TODO multiple currencies
            //for now we assume all the items have the same currency
            let currencyId = items[0].currency
            
            self.totalView.text = CurrencyManager.sharedCurrencyManager().getFormattedPrice(String(self.getTotalPrice(items)), currencyId: currencyId)

            self.showCartState(false)
            self.tableView.reloadData()
        }
    }
    
    func getTotalPrice(cartItems:CartItem[]) -> Double {

//TODO reduce
//        ???
//        why this doesn't compile "Could not find member 'price'", but it appears in autocompletion?
//        return cartItems.reduce(0, combine: {$0 + ($1.price * $1.quantity)})
//
        var total:Double = 0
        for cartItem in cartItems {
            let price:Double = NSString(string: cartItem.price).doubleValue
            let quantity:Double = Double(cartItem.quantity)
            total = total + (price * quantity)
        }
        
        return total
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "CartItemCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "CartItemCell")

        self.emptyCartView.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if !self.showingController {
            self.requestItems()
        }
        self.showingController = false
        
        self.adjustLayout()
    }
    
    func requestItems() {
        self.setProgressHidden(false, transparent: false)
        
        DataStore.sharedDataStore().getCart(
            
            {(items:CartItem[]!) -> Void in
            
                self.setProgressHidden(true, transparent: false)
                self.onRetrievedItems(items)
            
            }, failureHandler: {(Int) -> Bool in
                self.setProgressHidden(true, transparent: false)
                self.emptyCartView.hidden = false

                return false
                
            })
        
    }
    
    func adjustLayout() {
    
        self.navigationController.navigationBar.translucent = false;
    //    self.navigationController.toolbar.translucent = NO;
    //    self.tabBarController.tabBar.translucent = NO;
    
    //    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
        let screenBounds: CGRect = UIScreen.mainScreen().bounds
    
        let h:Float = screenBounds.size.height -
            (CGRectGetHeight(self.tabBarController.tabBar.frame)
            + CGRectGetHeight(self.navigationController.navigationBar.frame)
            + CGRectGetHeight(self.buyView.frame))
    
        self.tableView.frame = CGRectMake(0, CGRectGetHeight(self.buyView.frame), self.tableView.frame.size.width, h)
    ;
    //    self.tableView.contentInset = UIEdgeInsetsMake(0., 0., CGRectGetHeight(self.navigationController.navigationBar.frame) + CGRectGetHeight(self.tabBarController.tabBar.frame) + CGRectGetHeight(self.buyView.frame), 0);
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell! {
        let cellIdentifier:String = "CartItemCell"
        
        let cell: CartItemCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as CartItemCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let item: CartItem = items[indexPath.row]
        
        cell.productName.text = item.name
        cell.productDescr.text = item.descr
        cell.productBrand.text = item.seller
        
        cell.productPrice.text = CurrencyManager.sharedCurrencyManager().getFormattedPrice(item.price, currencyId: item.currency)
        
        cell.quantityField.text = String(item.quantity)
        
        cell.controller = self
        cell.tableView = self.tableView
        
        cell.productImg.setImageWithURL(NSURL.URLWithString(item.imgList))
        
        return cell
    }
    
    
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> Double {
        return 133
    }
    

    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let item:CartItem = items[indexPath.row]
            
            DataStore.sharedDataStore().removeFromCart(item.id, successHandler: {() -> Void in
                
                self.items.removeAtIndex(indexPath.row)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                
                self.onModifyLocalCartContent()
                
                }, failureHandler: {(Int) -> Bool in return false})
        }
    }
    
    func setQuantity(sender: AnyObject, atIndexPath ip:NSIndexPath) {
        let selectedCartItem:CartItem = items[ip.row]
        
        let quantities:Int[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
        
        let cartItemsForQuantitiesDialog:CartQuantityItem[] = self.wrapQuantityItemsForDialog(quantities)
        
        let selectQuantityController:SingleSelectionViewController = SingleSelectionViewController(style: UITableViewStyle.Plain)
        

        //FIXME
//        println(cartItemsForQuantitiesDialog.count) //11
//        var test:SingleSelectionItem[] = cartItemsForQuantitiesDialog as SingleSelectionItem[]
//        println(test.count) //this prints 318701632
        
        selectQuantityController.items = cartItemsForQuantitiesDialog
        
        println(selectQuantityController.items.count)
        
        selectQuantityController.delegate = self
        selectQuantityController.baseObject = selectedCartItem
        
        self.showingController = true
        self.presentModalViewController(selectQuantityController, animated: true)
    }
    
    func wrapQuantityItemsForDialog(quantities: Int[]) -> CartQuantityItem[] {
        return quantities.map {(let q) -> CartQuantityItem in CartQuantityItem(quantity: q)}
    }

    
    @IBAction func onBuyPress(sender: UIButton) {
        let paymentViewController:PaymentViewController = PaymentViewController(nibName:"CSPaymentViewController", bundle:nil)
        paymentViewController.totalValue = self.getTotalPrice(items)
        
//        TODO
//        paymentViewController.currency = [CSCurrency alloc]initWithId:<#(int)#> format:<#(NSString *)#>;
        
        self.navigationController.pushViewController(paymentViewController, animated: true)
    }

    func selectedItem(item: SingleSelectionItem, baseObject:AnyObject) {
        var cartItem = baseObject as CartItem //TODO use generics
        
        let quantity:Int = item.getWrappedItem() as Int //TODO use generics
        
        self.setProgressHidden(false, transparent:true)
        
        DataStore.sharedDataStore().setCartQuantity(cartItem.id, quantity: quantity,
            
            {() -> Void in
                
                cartItem.quantity = quantity
                self.tableView.reloadData()
                
                self.onModifyLocalCartContent()
                
                self.setProgressHidden(true, transparent:true)
                
                
            }, failureHandler: {(Int) -> Bool in return false
                self.setProgressHidden(true, transparent: true)
                
            })
    }

}