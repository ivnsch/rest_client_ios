//
//  User.swift
//  clojushop_client_ios
//
//  Created by ischuetz on 10/06/2014.
//  Copyright (c) 2014 ivanschuetz. All rights reserved.
//

import Foundation

let JSON_KEY_USER_ID = "id"
let JSON_KEY_USER_NAME = "una"
let JSON_KEY_USER_EMAIL = "uem"

class User {
    
    let id:String, name:String, email:String
    
    init(id:String, name:String, email:String) {
        self.id = id
        self.name = name
        self.email = email
    }
    
    convenience init(dict: NSDictionary) {
        self.init(
            id: dict.objectForKey(JSON_KEY_USER_ID) as NSString as String,
            name: dict.objectForKey(JSON_KEY_USER_NAME) as NSString as String,
            email: dict.objectForKey(JSON_KEY_USER_EMAIL) as NSString as String
        )
    }
}