//
//  ProfileVC.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 5/4/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit
import Auth0

class ProfileVC: ArtistProfileVC {
    
    var user_profile: UserInfo!
    
        override func viewDidLoad() {
            super.viewDidLoad()
            user_profile = SessionManager.shared.profile
            if let user = user_profile?.sub {
                self.getArtist(id: user)
                self.getFollowers(id: user)
                addButton()
            }
            
        }
    
    func addButton() {
              button.setTitle("Edit Profile", for: .normal)
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
              
              button.translatesAutoresizingMaskIntoConstraints = false
             
              view.addSubview(button)
              
              button.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
              button.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        
              button.isUserInteractionEnabled = true
              
              button.addTarget(self, action:#selector(buttonClicked), for: .touchUpInside)
              
              
          }
    
    
           @objc func buttonClicked() {
            navigationController?.pushViewController(EditProfileVC(), animated: true)
           }
   
}
