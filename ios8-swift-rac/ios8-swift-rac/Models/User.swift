//
//  User.swift
//  ios8-swift-rac
//
//  Created by Nicholas Tian on 18/05/2015.
//  Copyright (c) 2015 nickTD. All rights reserved.
//

import Foundation

class User: NSObject {
    dynamic var password: String {
        get {
            if let password = NSUserDefaults.standardUserDefaults().stringForKey("password") {
                return password
            } else {
                return "oops"
            }
        }
        set(newPassword) {
            NSUserDefaults.standardUserDefaults().setValue(newPassword, forKey: "password")
        }
    }

    let passwordKey = "password"
}
