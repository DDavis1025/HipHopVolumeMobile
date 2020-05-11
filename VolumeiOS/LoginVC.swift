//
//  LoginVC.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 5/6/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit

class LoginVC: UIViewController {
    var label = UILabel()
    var button = UIButton()
    var sfAuthSessionSwitch = UISwitch()
    
    @objc func applicationDidBecomeActive(_ notification: NSNotification) {
        checkState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !sfAuthSessionSwitch.isOn {
            checkState()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecomeActive(_:)),
            name: UIApplication.didBecomeActiveNotification,
            object: nil)
        
        addLoginLabel()
        addButton()
        updateUI()
    
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
        
        button.addTarget(self, action:#selector(buttonClick), for: .touchUpInside)
        
        
        
    }

    @objc func buttonClick(sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if AppDelegate.shared.tokens == nil {
            AppDelegate.shared.authServer.authorize(viewController: self, useSfAuthSession: sfAuthSessionSwitch.isOn, handler: { (success) in
                if !success {
                    //TODO: show error
                    self.updateUI()
                }
                if self.sfAuthSessionSwitch.isOn {
                    self.checkState()
                }
            })
        } else {
            print("token != nil")
            AppDelegate.shared.logout()
            print("AT \(AppDelegate.shared.tokens)")
            print("AP \(AppDelegate.shared.profile)")
            print("auth server \(AppDelegate.shared.authServer)")
            updateUI()
        }
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            if AppDelegate.shared.tokens == nil {
                if AppDelegate.shared.authServer.receivedCode == nil {
                    self.label.text = "Logged-out"
                } else {
                    self.label.text = "Finishing login..."
                }
                self.button.setTitle("Login", for: UIControl.State.normal)
                self.sfAuthSessionSwitch.isEnabled = true;
            } else {
                if AppDelegate.shared.profile?.name == nil {
                    self.label.text = "Hello, you are logged-in"
                } else {
                    self.label.text = "Hello, " + appDelegate.profile!.name! + ", you are logged-in"
                }
                self.button.setTitle("Logout", for: UIControl.State.normal)
                self.sfAuthSessionSwitch.isEnabled = false;
            }
        }
    }
    
    private func checkState() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if AppDelegate.shared.authServer.receivedCode != nil && AppDelegate.shared.authServer.receivedState != nil {
            AppDelegate.shared.authServer.getToken() { (tokens) in
                AppDelegate.shared.tokens = tokens
                if AppDelegate.shared.tokens != nil {
                    AppDelegate.shared.authServer.getProfile(accessToken: tokens!.accessToken, handler: { (profile) in
                        AppDelegate.shared.profile = profile
                        self.updateUI()
                    })
                } else {
                    // TODO: error getting token
                    print("hell logout")
                    AppDelegate.shared.logout()
                }
                self.updateUI()
            }
        }
    }
}
