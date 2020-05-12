//
//  AuthVC.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 5/11/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit
import Auth0

let domain = "https://dev-owihjaep.auth0.com"
let clientId = "1xSs0Ez95mih823mzKFxHWVDFh7iHX8y"

struct AuthStruct {
     let credentialsManager = CredentialsManager(authentication: Auth0.authentication())
}

class AuthVC: UIViewController {
    
    var label = UILabel()
    var button = UIButton()
    
    var profile: Auth0.UserInfo? = nil
    
    var auth = AuthStruct()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLoginLabel()
        addButton()
        
        self.navigationController?.isToolbarHidden = true
        self.navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = UIColor.white
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addLoginLabel() {
           label.text = ""
           view.addSubview(label)
           
           label.translatesAutoresizingMaskIntoConstraints = false
           
           label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
           
           label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
           
           label.isUserInteractionEnabled = true
           
           
           
       }
       
       func addButton() {
           button.setTitle("Login or Sign Up", for: .normal)
           button.titleLabel?.numberOfLines = 1
           button.titleLabel?.adjustsFontSizeToFitWidth = true
           button.titleLabel?.lineBreakMode = .byClipping
           button.setTitleColor(UIColor.black, for: .normal)
           button.titleLabel?.font =  UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
           button.backgroundColor = .clear
           button.layer.cornerRadius = 5
           button.layer.borderWidth = 2
           let spacing: CGFloat = 8.0
           button.layer.borderColor = UIColor.lightGray.cgColor
           button.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        
           view.addSubview(button)
           
           button.translatesAutoresizingMaskIntoConstraints = false
           
           button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
           
           button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
           
           button.isUserInteractionEnabled = true
           
           button.addTarget(self, action:#selector(buttonClicked), for: .touchUpInside)
           
           
       }

    @objc func buttonClicked(sender: UIButton) {
            Auth0
            .webAuth()
            .scope("openid offline_access profile")
            .parameters(["prompt":"login"])
            .audience("https://dev-owihjaep.auth0.com/userinfo")
            .start {
                switch $0 {
                case .failure(let error):
                    print("Error: \(error)")
                case .success(let credentials):
                    print(credentials.accessToken)
                    self.auth.credentialsManager.store(credentials: credentials)
                    if(!SessionManager.shared.store(credentials: credentials)) {
                        print("Failed to store credentials")
                    } else {
                        SessionManager.shared.retrieveProfile { error in
                            DispatchQueue.main.async {
                                self.navigationController?.pushViewController(MainView(), animated: true)
                                guard error == nil else {
                                    print("Failed to retrieve profile: \(String(describing: error))")
                                    return
                            }
                          }
                        }
                    }
                }
            }
        }

    
    func updateUI() {
        DispatchQueue.main.async {
            if self.profile != nil {
                self.label.text = "Hello, \(self.profile!.name ?? "user with no name"), you are logged in"
                self.button.setTitle("Logout", for: UIControl.State.normal)
            } else {
                self.label.text = "Logged-out"
                self.button.setTitle("Login", for: UIControl.State.normal)
            }
        }
    }
    
}
