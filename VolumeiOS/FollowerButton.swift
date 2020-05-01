//
//  FollowerButton.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 5/1/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit

class FollowerButton: UIButton {
    override init(frame:CGRect) {
        super.init(frame:frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setupButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .black, scale: .medium)
        let image = UIImage(systemName: "person.badge.plus.fill", withConfiguration: config) as UIImage?
        let blackImage = image?.withTintColor(.black, renderingMode: .alwaysOriginal)
        setImage(blackImage, for: .normal)
    }
    
    
    func addFollower(user_id:String, follower_id:String) {
        let follower = Follower(user_id: user_id, follower_id: follower_id)
        let postRequest = FollowerPostRequest(endpoint: "follower")
        
        postRequest.save(follower) { (result) in
            switch result {
            case .success(let follower):
                print("The following follower has been added \(follower.follower_id) to user \(follower.user_id)")
            case .failure(let error):
                print("An error occurred \(error)")
            }
        }
    }
}
