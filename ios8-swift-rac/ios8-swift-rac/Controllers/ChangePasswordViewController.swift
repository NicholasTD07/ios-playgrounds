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
    override func viewDidLoad() {
        super.viewDidLoad()

        var printText = { (text: AnyObject!) in println(text) }
        [currentPasswordTextField, newPasswordTextField, confirmPasswordTextField].map {
            $0.rac_textSignal().subscribeNext(printText)
        }

        currentPasswordTextField.rac_textSignal() ~> RAC(self.currentPasswordInputLabel, "text")
    }

}
