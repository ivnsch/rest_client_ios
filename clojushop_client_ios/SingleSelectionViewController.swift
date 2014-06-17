//
//  SingleSelectionViewController.swift
//  clojushop_client_ios
//
//  Created by ischuetz on 08/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import UIKit

class SingleSelectionViewController: UITableViewController {

      //FIXME the assignement from CartQuantityItem[] to SingleSelectionItem[] causes items.count to be 318701632
//    var items: SingleSelectionItem[]!
    var items: CartQuantityItem[]!
    
    var delegate: SingleSelectionControllerDelegate!
    var baseObject: AnyObject!

    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(style: UITableViewStyle)  {
        super.init(style: style)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
    }
    
    override func tableView(tableView:UITableView, numberOfRowsInSection section:NSInteger) -> Int {
//        println(items.count)
        return items.count
    }
    
    override func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell! {
        let cellIdentifier:String = "Cell"
        
        println(self.tableView)
        
         //FIXME this causes bad instruction error, but works in objc. 
         //recycling temporarily disabled. for quantities view controller this is not very important, since we have only a few items
//        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell
//        
//        if (cell == nil) {
            var cell = UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier:cellIdentifier)
//        }
        
        cell.textLabel.text = items[indexPath.row].getLabel()
        
        return cell;
    }

    override func tableView(tableView:UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        
        let item:SingleSelectionItem = items[indexPath.row]
        
        if (delegate != nil) {
            delegate.selectedItem(item, baseObject: baseObject)
        }
    
        self.dismissModalViewControllerAnimated(true)
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
