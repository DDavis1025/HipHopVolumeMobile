//
//  LoginVC.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 5/6/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
import Auth0

class LoginVC: Toolbar {

    var loginButton: UILabel?

    override func viewDidLoad() {
    super.viewDidLoad()
    
        
    }
    
    func addLoginLabel() {
        loginButton = UILabel()
        loginButton?.text = "Login"
        view.addSubview(loginButton!)
        
        loginButton?.translatesAutoresizingMaskIntoConstraints = false
        
        loginButton?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        loginButton?.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        loginButton?.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.loginClicked))
        loginButton?.addGestureRecognizer(gesture)
        
        
    }

    @objc func loginClicked() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.tokens == nil {
            appDelegate.authServer.authorize(viewController: self, useSfAuthSession: sfAuthSessionSwitch.isOn, handler: { (success) in
                if !success {
                    //TODO: show error
                    self.updateUI()
                }
                if self.sfAuthSessionSwitch.isOn {
                    self.checkState()
                }
            })
        } else {
            appDelegate.logout()
            updateUI()
        }
    }
    
    func authorize(viewController: UIViewController, useSfAuthSession: Bool, handler: @escaping (Bool) -> Void) {
        guard let challenge = generateCodeChallenge() else {
            // TODO: handle error
            handler(false)
            return
        }

        savedState = generateRandomBytes()

        var urlComp = URLComponents(string: domain + "/authorize")!

        urlComp.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "code_challenge_method", value: "S256"),
            URLQueryItem(name: "code_challenge", value: challenge),
            URLQueryItem(name: "state", value: savedState),
            URLQueryItem(name: "scope", value: "id_token profile"),
            URLQueryItem(name: "redirect_uri", value: "auth0test1://test"),
        ]

        if useSfAuthSession {
            sfAuthSession = SFAuthenticationSession(url: urlComp.url!, callbackURLScheme: "auth0test1", completionHandler: { (url, error) in
                guard error == nil else {
                    return handler(false)
                }

                handler(url != nil && self.parseAuthorizeRedirectUrl(url: url!))
            })
            sfAuthSession?.start()
        } else {
            sfSafariViewController = SFSafariViewController(url: urlComp.url!)
            viewController.present(sfSafariViewController!, animated: true)
            handler(true)
        }
    }
    
    
    
    
    
    
}
