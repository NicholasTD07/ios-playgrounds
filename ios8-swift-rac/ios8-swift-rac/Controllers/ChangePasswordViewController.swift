//
//  ChangePasswordViewController.swift
//  ios8-swift-rac
//
//  Created by Nicholas Tian on 17/05/2015.
//  Copyright (c) 2015 nickTD. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ChangePasswordViewController: UITableViewController {
    @IBOutlet weak var currentPasswordLabel: UILabel!
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var currentPasswordInputLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()

        user = User(password: "weak")

        setUpSignals()
    }

    func setUpSignals() {
        RACObserve(user, "password") ~> RAC(currentPasswordLabel, "text")
        currentPasswordTextField.rac_textSignal() ~> RAC(currentPasswordInputLabel, "text")
        saveButtonEnablingSignal()

        let validPasswordSignal = currentPasswordTextField
            .rac_textSignal()
            .mapAs {
                (text: NSString) -> NSNumber in
                return text.isEqualToString(self.user.password)
            }

        let newPasswordFieldsHaveInputs = RACSignal.combineLatest(
            [newPasswordTextField, confirmPasswordTextField].map { $0.rac_textSignal() }
            ).mapAs { (tuple: RACTuple) -> NSNumber in
                let texts = tuple.allObjects() as! [NSString]
                let haveInputs = texts.map { $0.length > 0 }
                // TODO: WAT?!
                // Bool is not convertible to NSNumber
//                return haveInputs.reduce(true) { $0 && $1 }
                let result = haveInputs.reduce(true) { $0 && $1 }
                return result
            }

        let matchingNewPasswordsSignal = confirmPasswordTextField
            .rac_textSignal()
            .mapAs {
                (password: NSString) -> NSNumber in
                println(password)
                return password.isEqualToString(self.newPasswordTextField.text)
            }

        let canChangePasswordSignal = RACSignal.combineLatest(
            [validPasswordSignal, newPasswordFieldsHaveInputs, matchingNewPasswordsSignal]).and()

        canChangePasswordSignal ~> RAC(self.saveButton, "enabled")
    }

}
