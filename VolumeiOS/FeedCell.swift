//
//  FeedCell.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 4/25/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit

class FeedCell:UITableViewCell {
    var albumImage = UIImageView()
    var albumTitle = UILabel()
    var imageLoader:DownloadImage?
    
    var components:URLComponents = {
        var component = URLComponents()
        component.scheme = "http"
        component.host = "localhost"
        component.port = 8000
        return component
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        albumImage.image = UIImage(named: "music-placeholder")
        addSubview(albumImage)
        addSubview(albumTitle)
        setImageConstraints()
        setTitleContstraints()
        
//        print("dataTask \(dataTask)")
        print("image datatask \(imageLoader?.dataTask)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoader?.dataTask?.cancel()
        albumImage.image = nil
    }
    
    func set(post: Post) {
        components.path = "/\(post.path)"
        print("post path \(post.path)")
        self.imageLoader = DownloadImage(urlString: components.url!.absoluteString)
//        self.imageLoader?.imageDidSet = { [weak self] image in
        self.albumImage.image = imageLoader?.image
//        }
        albumTitle.text = post.title
    }
    
    func configureImageView() {
        
    }
    
    func configureTitleLabel() {
        
    }
    
    func setImageConstraints() {
        albumImage.translatesAutoresizingMaskIntoConstraints = false
        albumImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        albumImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        albumImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        albumImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    
    func setTitleContstraints() {
        albumTitle.translatesAutoresizingMaskIntoConstraints = false
        albumTitle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        albumTitle.leadingAnchor.constraint(equalTo: albumImage.trailingAnchor, constant: 20).isActive = true
        albumTitle.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
}
