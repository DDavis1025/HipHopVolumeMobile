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
            }
            
        }
    
   
}
