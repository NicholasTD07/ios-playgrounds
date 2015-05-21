//
//  ChangePasswordViewModel.swift
//  ios8-swift-rac
//
//  Created by Nicholas Tian on 21/05/2015.
//  Copyright (c) 2015 nickTD. All rights reserved.
//

import Foundation
import ReactiveCocoa

class ChangePasswordViewModel: NSObject {
    let user: User
    var currentPasswordInput: String = "" { didSet { println("ViewModel - currentPassword: " + currentPasswordInput) } }
    var newPasswordInput: String = "" { didSet { println("ViewModel - newPassword: " + newPasswordInput) } }
    var confirmPasswordInput: String = "" { didSet { println("ViewModel - confirmPassword: " + confirmPasswordInput) } }

    init(user: User) {
        self.user = user
    }

    // MARK: signals
    // TODO: use lazy properties
    var currentPasswordValidSignal: RACSignal {
        return RACSignal
            .combineLatest([RACObserve(self.user, "password"), signalOf("currentPasswordInput")])
            .mapAs {
                (tuple: RACTuple) -> NSNumber in
                let userPassword = tuple.first as! String
                let inputPassword = tuple.second as! String
                return inputPassword == userPassword
            }
    }

    var newPasswrodsNotEmpty: RACSignal {
        return RACSignal
            .combineLatest(["newPasswordInput", "confirmPasswordInput"].map(signalOf))
            .mapAs {
                (tuple: RACTuple) -> NSNumber in
                let newPassword = tuple.first as! String
                let confirmPassword = tuple.second as! String
                return !newPassword.isEmpty && !confirmPassword.isEmpty
            }
    }

    var matchingNewPasswordsSignal: RACSignal {
        return RACSignal
            .combineLatest(["newPasswordInput", "confirmPasswordInput"].map(signalOf))
            .mapAs {
                (tuple: RACTuple) -> NSNumber in
                let newPassword = tuple.first as! String
                let confirmPassword = tuple.second as! String
                return confirmPassword == newPassword
            }
    }

    var canSavePasswordSignal: RACSignal {
        return RACSignal
            .combineLatest([
                currentPasswordValidSignal,
                newPasswrodsNotEmpty,
                matchingNewPasswordsSignal
            ])
            .and()
    }

    var savePasswordCommand: RACCommand {
        return RACCommand(enabled: canSavePasswordSignal) {
            (_) -> RACSignal in
            self.user.password = self.confirmPasswordInput
            return RACSignal.empty()
        }
    }

    // MARK: private
    private func signalOf(keyPath: String) -> RACSignal {
        return RACObserve(self, keyPath)
    }
}
