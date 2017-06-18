//
//  StoryboardViewController.swift
//  testttt
//
//  Created by tikhonov on 11/05/2017.
//  Copyright © 2017 tikhonov. All rights reserved.
//

import UIKit
import ATTextField

class StoryboardViewController: UIViewController {
    
    @IBOutlet var textField: ATTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // for hiding keyboard 
        addGestureRecognizer()
    }
    
    private func addGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        textField.showAlert(withText: "Alert message", withAnimation: true)
    }
    
    @objc private func hideKeyboard(gesture: UIGestureRecognizer?) {
        view.endEditing(true)
    }
}
