//
//  ProgViewController.swift
//  testttt
//
//  Created by tikhonov on 11/05/2017.
//  Copyright © 2017 tikhonov. All rights reserved.
//

import UIKit
import ATTextField

class ProgViewController: UIViewController {

    var emailTextField: ATTextField!
    var passwordTextField: ATTextField!
    var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create ATTextField
        createTextField()
        
        // configure rules for validation
        var emailCriteria = ATEmptyCriteria()
        emailCriteria.textField = emailTextField
        emailTextField.validator = ATValidator(criterias: [emailCriteria])
        
        var passwordCriteria = ATEmptyCriteria()
        passwordCriteria.textField = passwordTextField
        passwordTextField.validator = ATValidator(criterias: [passwordCriteria])
        
        
        // for hiding keyboard
        addGestureRecognizer()
    }
    
    private func addGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func loginButtonTapped(_ sender: Any) {
        emailTextField.validate(withAnimation: true)
        passwordTextField.validate(withAnimation: true)
    }
    
    @objc private func hideKeyboard(gesture: UIGestureRecognizer?) {
        view.endEditing(true)
    }

    func createTextField() {
        emailTextField = ATTextField()
        passwordTextField = ATTextField()
        button = UIButton(type: .system)
        
        button.backgroundColor = UIColor(red: 100.0/255.0, green: 135.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
        
        
        emailTextField.headColor = .pallette5
        emailTextField.headText = "E-mail"
        emailTextField.headLabel.font = UIFont.defaultFont(ofSize: 13.0, for: .medium)
        let placeholderAttributes = [
            NSForegroundColorAttributeName: UIColor.pallette3.withAlphaComponent(0.6),
            NSFontAttributeName : UIFont.defaultFont(ofSize: 16.0, for: .medium)
        ]
        emailTextField.attributedPlaceholder = NSAttributedString(string: "E-mail", attributes: placeholderAttributes)
        emailTextField.baseColor = .pallette6
        emailTextField.alertColor = .pallette7
        emailTextField.alertLabel.font = UIFont.defaultFont(ofSize: 12.0, for: .medium)
        emailTextField.font = UIFont.defaultFont(ofSize: 16.0, for: .medium)
        emailTextField.textColor = .pallette3
        emailTextField.keyboardType = .emailAddress
        emailTextField.returnKeyType = .next
        emailTextField.autocorrectionType = .no
        emailTextField.baseLinePadding = CGPoint(x: 0, y: 10.0)
        emailTextField.textFieldAreaPadding = CGPoint(x: 0, y: 10.0)
        emailTextField.alertLabelPadding = CGPoint(x: 0, y: 5.0)
        emailTextField.hideAlertWhenDidEndEditingPassValidation = true
        emailTextField.hideHeadWhenTextFieldIsEmpty = true
        
        
        passwordTextField.headColor = .pallette5
        passwordTextField.headText = "Password"
        passwordTextField.headLabel.font = UIFont.defaultFont(ofSize: 13.0, for: .medium)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: placeholderAttributes)
        passwordTextField.baseColor = .pallette6
        passwordTextField.alertColor = .pallette7
        passwordTextField.alertLabel.font = UIFont.defaultFont(ofSize: 12.0, for: .medium)
        passwordTextField.font = UIFont.defaultFont(ofSize: 16.0, for: .medium)
        passwordTextField.textColor = .pallette3
        passwordTextField.returnKeyType = .go
        passwordTextField.isSecureTextEntry = true
        passwordTextField.baseLinePadding = CGPoint(x: 0, y: 10.0)
        passwordTextField.textFieldAreaPadding = CGPoint(x: 0, y: 10.0)
        passwordTextField.alertLabelPadding = CGPoint(x: 0, y: 5.0)
        passwordTextField.hideAlertWhenDidEndEditingPassValidation = true
        passwordTextField.hideHeadWhenTextFieldIsEmpty = true
        
        
        layoutTextFields()
    }

    func layoutTextFields() {
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(button)
        
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            emailTextField.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            emailTextField.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 16.0),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16.0),
            button.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            button.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16.0),
            button.heightAnchor.constraint(equalToConstant: 40.0)
            ])
    }
}
