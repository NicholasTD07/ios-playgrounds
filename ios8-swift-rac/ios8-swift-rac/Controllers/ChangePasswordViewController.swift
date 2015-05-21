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

        currentPasswordTextField
            .rac_textSignal()
            .filterAs
            {
                (input: NSString) -> Bool in
                return input.length > 3
            }
            .map {
                (input: AnyObject!) -> AnyObject! in
                let inputAsString = input as! String
                return ("log: " + inputAsString) as NSString
            }
            .subscribeNext { (input: AnyObject!) -> Void in
                println(input)
            }
    }

}
