//
//  EditProfileVC.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 5/12/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit

class EditProfileVC: Toolbar, UITextFieldDelegate {
    
      let user_profile = SessionManager.shared.profile
      var imageLoader:DownloadImage?
      var imageView = UIImageView()
      var button = UIButton()
      let userTextField =  UITextField()
      let emailTextField = UITextField()
      let userLabel = UILabel()
      let emailLabel = UILabel()
    
        override func viewDidLoad() {
            super.viewDidLoad()
            setProfileImage()
            addUserTextField()
            addEmailTextField()
            addEmailLabel()
            addUserLabel()
            addUserConstraints()
            addEmailConstraints()
            view.backgroundColor = UIColor.white
        
        }
    
    
        func setProfileImage() {
         imageLoader = DownloadImage()
         self.imageLoader?.imageDidSet = { [weak self] image in
            self?.imageView.image = image
            print("image \(image)")
            if let imageView = self?.imageView {
             self?.view?.addSubview(imageView)
                self?.setImageContraints()
                        self?.addButton()
            }
              }
            imageLoader?.downloadImage(urlString: (user_profile?.picture!.absoluteString)!)
            print("url string \((user_profile?.picture!.absoluteString)!)")
          }
    
        func setImageContraints() {
            self.imageView.translatesAutoresizingMaskIntoConstraints = false
            self.imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
            self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
            self.imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
           }
    
        func addButton() {
                  button.setTitle("Change Photo", for: .normal)
                  button.setTitleColor(UIColor.blue, for: .normal)
                  button.titleLabel?.font =  UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
               
                  view.addSubview(button)
                  
                  button.translatesAutoresizingMaskIntoConstraints = false
                  
                  button.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
                  
                  button.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5).isActive = true
                  
                  button.isUserInteractionEnabled = true
                  
                  button.addTarget(self, action:#selector(buttonClicked), for: .touchUpInside)
                  
                  
              }
    
         func addUserLabel() {
           userLabel.text = "Username:"
           self.view.addSubview(userLabel)
            
         }
    
        func addEmailLabel() {
           emailLabel.text = "Email:"
           self.view.addSubview(emailLabel)
           
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
                     
                    userTextField.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20).isActive = true
                    userTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
                    userTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
                     
                    userTextField.leadingAnchor.constraint(equalTo: userLabel.trailingAnchor, constant: 5).isActive = true
        
                    userTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
                    userLabel.translatesAutoresizingMaskIntoConstraints = false
                    
                    userLabel.centerYAnchor.constraint(equalTo: userTextField.centerYAnchor).isActive = true
                   
                    userLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
       }
    
       
          
        
    
        func addEmailTextField() {

          emailTextField.placeholder = "Enter email"
          emailTextField.font = UIFont.systemFont(ofSize: 15)
          emailTextField.borderStyle = UITextField.BorderStyle.roundedRect
          emailTextField.autocorrectionType = UITextAutocorrectionType.no
          emailTextField.keyboardType = UIKeyboardType.default
          emailTextField.returnKeyType = UIReturnKeyType.done
          emailTextField.clearButtonMode = UITextField.ViewMode.whileEditing
          emailTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
          emailTextField.delegate = self
          self.view.addSubview(emailTextField)
            
        }
    
    
       func addEmailConstraints() {
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
          
        emailTextField.topAnchor.constraint(equalTo: userTextField.bottomAnchor, constant: 7).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        emailTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
                            
        emailTextField.leadingAnchor.constraint(equalTo: emailLabel.trailingAnchor, constant: 5).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
                    
        emailLabel.centerYAnchor.constraint(equalTo: emailTextField.centerYAnchor).isActive = true
                   
        emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
       }
    
        @objc func buttonClicked() {
         print("change photo clicked")
        }
    
    
    
        
    
    
    
}

