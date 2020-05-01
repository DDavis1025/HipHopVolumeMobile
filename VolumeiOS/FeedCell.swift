//
//  FeedCell.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 4/25/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit
import Combine

class FeedCell:UITableViewCell {
    var albumImage = UIImageView()
    var albumPH = UIImageView()
    var albumArtist = UILabel()
    var albumTitle = UILabel()
    var artistImage = UIImageView()
    var imageLoader:DownloadImage?
    var imageLoaded:Bool? = false
    var userModel:GetUserByIDVM2?
    var user:[UsersModel]?
    var postAuthor:String?
    
     static var shared = FeedCell()
    
    var components:URLComponents = {
        var component = URLComponents()
        component.scheme = "http"
        component.host = "localhost"
        component.port = 8000
        return component
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        albumPH.image = UIImage(named: "music-placeholder")
//        albumPH.image = UIImage(named: "music-placeholder")
        addSubview(albumPH)
        setImagePHConstraints()

        addSubview(albumImage)
        addSubview(albumTitle)
        addSubview(albumArtist)
        addSubview(artistImage)
        setImageConstraints()
        setTitleContstraints()
        setArtistContstraints()
        setArtistImageContstraints()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoader?.dataTask?.cancel()
        albumImage.image = nil
//        albumPH.image = nil

    }
    
    func set(post: Post) {
        components.path = "/\(post.path)"
       
        self.imageLoader = DownloadImage()
        imageLoader?.imageDidSet = { [weak self] image in
            self?.albumImage.image = image
            }
        imageLoader?.downloadImage(urlString: components.url!.absoluteString)
        albumTitle.text = post.title
        albumPH.image = nil
        
        
    }
    
    func setUser(user: UsersModel?) {
        albumArtist.text = user?.name ?? "undefined"
        self.imageLoader = DownloadImage()
           imageLoader?.imageDidSet = { [weak self] image in
                self?.artistImage.image = image
              }
        if let userPicture = user?.picture {
        imageLoader?.downloadImage(urlString: userPicture)
        }
    }
    
    func configureImageView() {
        
    }
    
    func configureTitleLabel() {
        
    }
    
    func setImageConstraints() {
        albumImage.translatesAutoresizingMaskIntoConstraints = false
        albumImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        albumImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        albumImage.heightAnchor.constraint(equalToConstant: 90).isActive = true
        albumImage.widthAnchor.constraint(equalToConstant: 90).isActive = true
        
    }
    
    func setImagePHConstraints() {
        albumPH.translatesAutoresizingMaskIntoConstraints = false
        albumPH.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        albumPH.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        albumPH.heightAnchor.constraint(equalToConstant: 90).isActive = true
        albumPH.widthAnchor.constraint(equalToConstant: 90).isActive = true
        
    }
    
    func setArtistContstraints() {
          albumArtist.translatesAutoresizingMaskIntoConstraints = false
          albumArtist.centerXAnchor.constraint(equalTo: albumTitle.centerXAnchor).isActive = true
           albumArtist.bottomAnchor.constraint(equalTo: albumTitle.topAnchor, constant: -5).isActive = true
           albumArtist.heightAnchor.constraint(equalToConstant: 20).isActive = true
       }
    
    func setArtistImageContstraints() {
              artistImage.translatesAutoresizingMaskIntoConstraints = false
              artistImage.centerYAnchor.constraint(equalTo: albumArtist.centerYAnchor).isActive = true
              artistImage.trailingAnchor.constraint(equalTo: albumArtist.leadingAnchor, constant: -3).isActive = true
              artistImage.heightAnchor.constraint(equalToConstant: 25).isActive = true
              artistImage.leadingAnchor.constraint(equalTo: albumTitle.leadingAnchor).isActive = true
              artistImage.widthAnchor.constraint(equalToConstant: 25).isActive = true
          }
    
    
    func setTitleContstraints() {
        albumTitle.translatesAutoresizingMaskIntoConstraints = false
        albumTitle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        albumTitle.leadingAnchor.constraint(equalTo: albumImage.trailingAnchor, constant: 20).isActive = true
        albumTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    
}
