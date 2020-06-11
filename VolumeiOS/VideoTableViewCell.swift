//
//  VideoTableViewCell.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 6/8/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit
import Combine

class VideoTableViewCell: FeedCell {
    
    override func setImageConstraints() {
        super.setImageConstraints()
        mediaImage.heightAnchor.constraint(equalToConstant: 60.7).isActive = true
        mediaImage.widthAnchor.constraint(equalToConstant: 108).isActive = true
        
    }
    
    override func setImagePHConstraints() {
        super.setImagePHConstraints()
        mediaPH.heightAnchor.constraint(equalToConstant: 60.7).isActive = true
        mediaPH.widthAnchor.constraint(equalToConstant: 108).isActive = true
        
    }
    
   
    
    
}
