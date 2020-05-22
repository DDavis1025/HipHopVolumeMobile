//
//  UsernameTextField.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 5/19/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit

protocol MyDataSendingDelegateProtocol {
    func sendDataToEditProfileVC(myData: Bool)
}

class UsernameTextField: Toolbar, UITextFieldDelegate {
    
    var delegate: MyDataSendingDelegateProtocol? = nil
    
    var user_profile = SessionManager.shared.profile
    let userTextField =  UITextField()
    let userLabel = UILabel()
    var save = UIButton()
    let updateUser = UpdateUserInfo()
    var usernameWarning:UILabel?
    let editPF = EditPFStruct()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addUserTextField()
        usernameTaken()
        addUserLabel()
        addUserConstraints()
        addNavButtons()
        
        view.backgroundColor = UIColor.white
        
    }
    
   
    
    func addUserLabel() {
        userLabel.text = "Username:"
        self.view.addSubview(userLabel)
        
    }
    
    
    func addUserTextField() {
        
        userTextField.placeholder = "Enter username"
        userTextField.font = UIFont.systemFont(ofSize: 15)
        userTextField.borderStyle = UITextField.BorderStyle.roundedRect
        userTextField.autocorrectionType = UITextAutocorrectionType.no
        userTextField.keyboardType = UIKeyboardType.default
        userTextField.returnKeyType = UIReturnKeyType.done
        userTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        userTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        userTextField.delegate = self
        self.view.addSubview(userTextField)
        
        
    }
    
    func addUserConstraints() {
        userTextField.translatesAutoresizingMaskIntoConstraints = false
        
        userTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        userTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        userTextField.leadingAnchor.constraint(equalTo: userLabel.trailingAnchor, constant: 5).isActive = true
        
        userTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        
        userLabel.centerYAnchor.constraint(equalTo: userTextField.centerYAnchor).isActive = true
        
        userLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
    }
    
    
    func addNavButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(doneTapped))
    }
    
    
    @objc func cancelTapped(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func doneTapped(sender: UIBarButtonItem) {
        updateUsername()
    }
    
   
    func updateUsername() {
        if userTextField.text != "" {
            let usernameValidation = UsernameValidation()
            usernameValidation.getUsername(username: userTextField.text!) {
                if $0.count > 0 {
                    print("$0 username \($0)")
                    self.usernameWarning?.isHidden = false
                    print("$0.count > 0 username")
                } else {
                    self.usernameWarning?.isHidden = true
                    print("username accepted \($0)")
                    print("username text field \(self.userTextField.text!)")
                    self.updateUser.updateUserInfo(parameters: ["username": self.userTextField.text!], user_id: self.user_profile!.sub) {
                        print("done")
                        self.delegate?.sendDataToEditProfileVC(myData: true)
                    }
                    self.navigationController?.popViewController(animated: true)
                    }
                }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == userTextField {
            self.usernameWarning?.isHidden = true
        }
    }
    
    func usernameTaken() {
        usernameWarning = UILabel()
        usernameWarning?.text = "⚠ This username is already taken"
        usernameWarning?.textColor = UIColor.red
        usernameWarning?.isHidden = true
        view.addSubview(usernameWarning!)
        usernameWarningConstraints()
    }
    
    func usernameWarningConstraints() {
        usernameWarning?.translatesAutoresizingMaskIntoConstraints = false
        
        usernameWarning?.topAnchor.constraint(equalTo: userTextField.bottomAnchor, constant: 7).isActive = true

        usernameWarning?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        usernameWarning?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    
    
    
    
}


