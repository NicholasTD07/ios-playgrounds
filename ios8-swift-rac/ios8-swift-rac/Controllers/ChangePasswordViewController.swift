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

    var viewModel: ChangePasswordViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpRAC()
    }

    func setUpRAC() {
        currentPasswordTextField.rac_textSignal() ~> RAC(self.currentPasswordInputLabel, "text")

        currentPasswordTextField.rac_textSignal() ~> RAC(self.viewModel, "currentPasswordInput")
        newPasswordTextField.rac_textSignal() ~> RAC(self.viewModel, "newPasswordInput")
        confirmPasswordTextField.rac_textSignal() ~> RAC(self.viewModel, "confirmPasswordInput")
    }

}
