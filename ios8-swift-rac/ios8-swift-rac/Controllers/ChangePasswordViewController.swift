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

    var viewModel: ChangePasswordViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        registerUserPassword()

        currentPasswordTextField.rac_textSignal() ~> RAC(currentPasswordInputLabel, "text")

        viewModel = ChangePasswordViewModel(user: User())

        bindWithViewModel()
    }

    func registerUserPassword() {
        NSUserDefaults.standardUserDefaults().registerDefaults(["password": "fox"])
    }

    func bindWithViewModel() {
        RACObserve(viewModel.user, "password") ~> RAC(currentPasswordLabel, "text")
        currentPasswordTextField.rac_textSignal() ~> RAC(viewModel, "currentPasswordInput")
        newPasswordTextField.rac_textSignal() ~> RAC(viewModel, "newPasswordInput")
        confirmPasswordTextField.rac_textSignal() ~> RAC(viewModel, "confirmPasswordInput")

        saveButton.rac_command = viewModel.savePasswordCommand
        saveButton.rac_command.executionSignals
            .subscribeNext { [unowned self] (_) in
                self.currentPasswordTextField.text = ""
                self.currentPasswordInputLabel.text = ""
                self.newPasswordTextField.text = ""
                self.confirmPasswordTextField.text = ""
            }

    }
}
