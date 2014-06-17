//
//  DataStoreLocal.swift
//  clojushop_client_ios
//
//  Created by ischuetz on 09/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import Foundation
import CoreData


class DataStoreLocal {

    var context: NSManagedObjectContext!
    var model: NSManagedObjectModel!

    init() {
        model = NSManagedObjectModel.mergedModelFromBundles(nil)
        
        let psc:NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        let path:String = self.itemArchivePath()
        let storeUrl:NSURL = NSURL(fileURLWithPath: path)
        
        var error:NSError?
        if !psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeUrl, options: nil, error: &error) {
            NSException(name: "Open failed", reason: error!.localizedDescription, userInfo: nil).raise()
        }
        
        context = NSManagedObjectContext()
        context.persistentStoreCoordinator = psc
        
        context.undoManager = nil
    }

    func itemArchivePath() -> String {
        let documentDirectories = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectory:String = documentDirectories[0] as String
        return documentDirectory.stringByAppendingPathComponent("store.data")
    }

    func saveChanges() {
        var error:NSError?
        let success = context.save(&error)
        if (!success) {
            println("Error saving: " + error!.localizedDescription)
        }
    }
    
    func getProducts(start: Int, size: Int, successHandler: (products:AnyObject[]) -> (), failureHandler: () -> ()) {
        let request:NSFetchRequest = NSFetchRequest()
        
        let entityDescription:NSEntityDescription = model.entitiesByName["ProductCD"] as NSEntityDescription
        request.entity = entityDescription
        
        let sortDescription:NSSortDescriptor = NSSortDescriptor(key: "ordering", ascending: true)
        request.sortDescriptors = [sortDescription]
        
        var error:NSError?
        let result = context.executeFetchRequest(request, error: &error)
        
        if (!result) {
            println("Fetch failed, reason: " + error!.localizedDescription)
            failureHandler()
        } else {
            successHandler(products: result)
        }
    }
    
    func clearProducts() {
        let request:NSFetchRequest = NSFetchRequest()
        request.entity = NSEntityDescription.entityForName("ProductCD", inManagedObjectContext: context)
        let result = context.executeFetchRequest(request, error: nil)
        for productCD in result {
            context.deleteObject(productCD as NSManagedObject)
        }
    }
    
    func saveProducts(products:Product[]) {
        for i:Int in 0..products.count {
            let product:Product = products[i]
            let ordering:Double = Double(i + 1)
            self.saveProduct(product, ordering: ordering)
        }
    
        self.saveChanges()
    }
    
    func saveProduct(product:Product, ordering: Double) {
        let productCD:ProductCD = NSEntityDescription.insertNewObjectForEntityForName("ProductCD", inManagedObjectContext: context) as ProductCD
        productCD.id = product.id;
        productCD.name = product.name;
        productCD.descr = product.descr;
        productCD.price = product.price;
        productCD.currency = product.currency;
        productCD.seller = product.seller;
        productCD.img_pl = product.imgList;
        productCD.img_pd = product.imgDetails;
        productCD.ordering = ordering;
    }
}

