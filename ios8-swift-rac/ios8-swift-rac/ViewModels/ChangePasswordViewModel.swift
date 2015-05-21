//
//  ChangePasswordViewModel.swift
//  ios8-swift-rac
//
//  Created by Nicholas Tian on 21/05/2015.
//  Copyright (c) 2015 nickTD. All rights reserved.
//

import Foundation

class ChangePasswordViewModel: NSObject {
    let user: User
    var currentPasswordInput: String = "" { didSet { println("ViewModel: " + currentPasswordInput) } }
    var newPasswordInput: String = "" { didSet { println("ViewModel: " + newPasswordInput) } }
    var confirmPasswordInput: String = "" { didSet { println("ViewModel: " + confirmPasswordInput) } }

    init(user: User) {
        self.user = user
    }

    var userPassword: String {
        return user.password
    }

    var currentPasswordMatches: Bool {
        return currentPasswordInput == userPassword
    }

    var newPasswordConfirmed: Bool {
        return newPasswordInput == confirmPasswordInput
    }
}
