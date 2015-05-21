//
//  AppDelegate.swift
//  ios8-swift-rac
//
//  Created by Nicholas Tian on 5/17/15
//  Copyright (c) 2015 . All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func applicationDidFinishLaunching(application: UIApplication) {
        if let nvc = self.window!.rootViewController as? UINavigationController,
            let vc = nvc.topViewController as? ChangePasswordViewController {
                let user = User(password: "password")
                let changePasswordViewModel = ChangePasswordViewModel(user: user)
                vc.viewModel = changePasswordViewModel
        }
    }
}
