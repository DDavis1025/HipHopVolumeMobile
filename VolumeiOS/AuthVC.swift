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

class AuthVC: UIViewController {
    
    var label = UILabel()
    var button = UIButton()
    
    var profile: Auth0.UserInfo? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLoginLabel()
        addButton()
        
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
           button.setTitle("Login", for: .normal)
           button.backgroundColor = UIColor.black
           view.addSubview(button)
           
           button.translatesAutoresizingMaskIntoConstraints = false
           
           button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
           
           button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
           
           button.isUserInteractionEnabled = true
           
           button.addTarget(self, action:#selector(buttonClicked), for: .touchUpInside)
           
           
       }

    @objc func buttonClicked(sender: UIButton) {
        if profile != nil {
            profile = nil
            updateUI()
        } else {
            Auth0
                .webAuth(clientId: clientId, domain: domain)
                .parameters(["prompt":"login"])
                .scope("openid token profile")
                .start { result in
                    
                    switch result {
                    
                    case .success(let credentials):
                        Auth0
                            .authentication(clientId: clientId, domain: domain)
                            .userInfo(withAccessToken: credentials.accessToken!)
                            .start { result in
                    
                                switch result {
                                
                                case .success(let profile):
                                    self.profile = profile
                                
                                case .failure(let error):
                                    print("Failed with \(error)")
                                    self.profile = nil
                                }
                                
                                self.updateUI()
                        }
                    
                    case .failure(let error):
                        self.profile = nil
                        print("Failed with \(error)")
                    }
                    
                    self.updateUI()
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
