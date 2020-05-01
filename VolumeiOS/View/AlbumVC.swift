//
//  AlbumVC.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 4/23/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

class AlbumVC: Toolbar {
    
    var post:Post?
    var components = URLComponents()
    var viewController:UIViewController?
    var imageView = UIImageView()
    var albumTitle: UILabel?
    var albumDescription:UILabel?
    var user:UILabel?
    var userModel:GetUserByIDVM?
    var image:UIImageView?
    var userImageView:UIImageView?
    var child:SpinnerViewController?
    var imageLoader:DownloadImage?
    var userImage:String?
    var authorID:String?
    var user_id:String?
    var followButton = FollowerButton()
    var profile = SessionManager.shared.profile
 init(post: Post) {
    self.post = post
    print("post Album \(post)")
    viewController = ViewController(post:post)
    
       components.scheme = "http"
       components.host = "localhost"
       components.port = 8000
    
    authorID = self.post?.author!
    self.userModel = GetUserByIDVM(id: (authorID!))

    
    
    super.init(nibName: nil, bundle: nil)
    
    
    

}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
    super.viewDidLoad()
        addSpinner()
        
            self.userModel?.usersDidChange = { [weak self] users in
            self?.user = UILabel()
            self?.user!.text = users[0].name
            self?.user_id = users[0].user_id
            self?.view.addSubview(self!.user!)
            self?.addImageAfterLoad()
            self?.imageLoader?.downloadImage(urlString: users[0].picture!)
            self?.setFollowButtonConstraints()
//            self?.setUsersConstraints()
        }
        addImage()
        
        imageView.image = UIImage(named: "music-placeholder")
        self.view.addSubview(imageView)
        setImageViewConstraints()

        view.addSubview(followButton)
        
//        imageViewVC()
        addAlbumImage()
        addLabels()
        addViewController()
        addActionFollowBtn()
        view.backgroundColor = UIColor.white


        

        
    }
    
    func addImage() {
        let imagePH = UIImage(named: "profile-placeholder-user")
        userImageView = UIImageView(image: imagePH)
        view.addSubview(userImageView!)
        setUsersConstraints()
    }
    
    func addImageAfterLoad() {
        imageLoader = DownloadImage()
        self.imageLoader?.imageDidSet = { [weak self] image in
              self?.userImageView?.image = image
              self!.view.addSubview(self!.userImageView!)
              
              self!.setUsersConstraints()
              self?.child?.willMove(toParent: nil)
              self?.child?.view.removeFromSuperview()
              self?.child?.removeFromParent()
            
            let tap = UITapGestureRecognizer(target: self, action:  #selector(self?.userAction))
            let tap2 = UITapGestureRecognizer(target: self, action:  #selector(self?.userAction))
            
            self?.userImageView?.addGestureRecognizer(tap)
            self?.user?.addGestureRecognizer(tap2)
//
            self?.user?.isUserInteractionEnabled = true
            self?.userImageView?.isUserInteractionEnabled = true
    }

}
    
    func addSpinner() {
        self.child = SpinnerViewController()
        addChild(self.child!)
        self.child!.view.frame = view.frame
        view.addSubview(self.child!.view)
        self.child!.didMove(toParent: self)
        self.child!.view.backgroundColor = UIColor.white
        self.view.bringSubviewToFront(self.child!.view)
    }
    
    func setUsersConstraints() {
               userImageView?.translatesAutoresizingMaskIntoConstraints = false
        userImageView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
               userImageView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
               userImageView?.widthAnchor.constraint(equalToConstant: 50).isActive = true
               userImageView?.heightAnchor.constraint(equalToConstant: 50).isActive = true
               user?.translatesAutoresizingMaskIntoConstraints = false
               user?.leadingAnchor.constraint(equalTo: userImageView!.trailingAnchor, constant: 10).isActive = true
               user?.centerYAnchor.constraint(equalTo: userImageView!.centerYAnchor).isActive = true
        
        
         
    }
    
    @objc func userAction(sender : UITapGestureRecognizer) {
    let artistPFVC = ArtistProfileVC()
    artistPFVC.artistID = authorID
    navigationController?.pushViewController(artistPFVC, animated: true)
    print("clicked")
    }
    

    
    func addAlbumImage() {
        imageLoader = DownloadImage()
        self.imageLoader?.imageDidSet = { [weak self] image in
            self!.imageView.image = image
            self!.view.addSubview((self?.imageView)!)
            self?.setImageViewConstraints()
        }
        components.path = "/\(post!.path)"
        if let url = components.url?.absoluteString {
            imageLoader?.downloadImage(urlString: url)
            print("components url plus \(url)")
        }

//        print("components url \(url)")
    }
    
    func setImageViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 310).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 310).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: userImageView!.bottomAnchor, constant: 20).isActive = true
}
    
    func addLabels() {
        albumTitle = UILabel()
        let boldText = "Title: "
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)

        let normalText = (post!.title)!
        let normalString = NSMutableAttributedString(string:normalText)

        attributedString.append(normalString)
        
        albumTitle!.attributedText = attributedString
        
        albumDescription = UILabel()
        
        let boldTextDesc = "Description: "
        let attrsDesc = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)]
        let attributedStringDesc = NSMutableAttributedString(string:boldTextDesc, attributes:attrsDesc)

        let normalTextDesc = (post!.description)!
        let normalStringDesc = NSMutableAttributedString(string:normalTextDesc)

        attributedStringDesc.append(normalStringDesc)
        
        albumDescription!.attributedText = attributedStringDesc

        
        view.addSubview(albumTitle!)
        view.addSubview(albumDescription!)
        
        addLabelConstraints()
    }
    

        func addLabelConstraints() {
            self.albumTitle?.translatesAutoresizingMaskIntoConstraints = false
            self.albumDescription?.translatesAutoresizingMaskIntoConstraints = false
                                                                         
            albumTitle?.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
            
            albumDescription?.topAnchor.constraint(equalTo: albumTitle!.bottomAnchor, constant: 20).isActive = true
            
            albumTitle?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
              albumTitle?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
           
            albumDescription?.numberOfLines = 3
//            albumDescription?.lineBreakMode = .byWordWrapping
             albumDescription?.adjustsFontSizeToFitWidth = false
             albumDescription?.lineBreakMode = .byTruncatingTail
            albumDescription?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
            albumDescription?.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor).isActive = true
        }
    
    func addViewController() {
        addChild(viewController!)
        view.addSubview(viewController!.view)
        viewController!.didMove(toParent: self)
        setVCConstraints()

    }
    
    func setVCConstraints() {
        viewController?.view.translatesAutoresizingMaskIntoConstraints = false
        viewController?.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
              
        viewController?.view.topAnchor.constraint(equalTo: albumDescription!.bottomAnchor, constant: 20).isActive = true

        viewController?.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

        viewController?.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func addActionFollowBtn() {
        followButton.addTarget(self, action: #selector(followBtnTapped), for: .touchUpInside)
    }
    
    func setFollowButtonConstraints() {
        followButton.translatesAutoresizingMaskIntoConstraints = false
        
        followButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        followButton.centerYAnchor.constraint(equalTo: user!.centerYAnchor).isActive = true
    }

    
    @objc func followBtnTapped() {
        let follower_id = (profile?.sub)!
        followButton.addFollower(user_id: user_id!, follower_id: follower_id)
    }
    
   
    

}


struct AlbumController: UIViewControllerRepresentable {
    var post:Post
    func makeUIViewController(context: UIViewControllerRepresentableContext<AlbumController>) -> AlbumVC {
        return AlbumVC(post: post)
    }
    
    func updateUIViewController(_ uiViewController: AlbumVC, context: UIViewControllerRepresentableContext<AlbumController>) {

    }
    
    
}
