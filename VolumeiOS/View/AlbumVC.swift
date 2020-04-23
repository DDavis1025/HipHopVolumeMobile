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
    var imageView:UIViewController?
    var albumTitle: UILabel?
    var albumDescription:UILabel?
    var user:UILabel?
    var userModel:GetUserByIDVM?
   
 init(post: Post) {
    self.post = post
    print("post Album \(post)")
    viewController = ViewController(post:post)
    
       components.scheme = "http"
       components.host = "localhost"
       components.port = 8000
    
     
    
     super.init(nibName: nil, bundle: nil)
    

}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
    super.viewDidLoad()
        self.userModel = GetUserByIDVM(id: (self.post?.author!)!)
        addUser()
        userModel?.usersDidChange = { [weak self] users in
        print("um users \(users)")
        self?.user!.text = users[0].name
        }

        imageViewVC()
        addLabels()
        addViewController()
        view.backgroundColor = UIColor.white
        
    }
    
    func addUser() {
        user = UILabel()
        
        view.addSubview(user!)
        setUsersConstraints()
        
    }
    
    func setUsersConstraints() {
            user?.translatesAutoresizingMaskIntoConstraints = false
            user?.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
            user?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
    }
    
    func imageViewVC() {
           print("image view vc")
           components.path = "/\(post!.path)"
           imageView = UIHostingController(rootView: ImageView(withURL: components.url!.absoluteString))
           print("url components \(components.url)")
           addChild(imageView!)
           view.addSubview(imageView!.view)
           imageView?.didMove(toParent: self)
           setImageViewVCConstraints()
       }
    
    func setImageViewVCConstraints() {
        imageView?.view.translatesAutoresizingMaskIntoConstraints = false
        if let thisUser = user {
            imageView?.view.topAnchor.constraint(equalTo: thisUser.bottomAnchor).isActive = true
        }
        imageView?.view.widthAnchor.constraint(equalToConstant: 320).isActive = true
        imageView?.view.heightAnchor.constraint(equalToConstant: 320).isActive = true
        imageView?.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
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
                                                                         
            albumTitle?.topAnchor.constraint(equalTo: imageView!.view.bottomAnchor, constant: 20).isActive = true
            
            albumDescription?.topAnchor.constraint(equalTo: albumTitle!.bottomAnchor, constant: 20).isActive = true
            
            albumTitle?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
            albumDescription?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
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

    
   
    

}


struct AlbumController: UIViewControllerRepresentable {
    var post:Post
    func makeUIViewController(context: UIViewControllerRepresentableContext<AlbumController>) -> AlbumVC {
        return AlbumVC(post: post)
    }
    
    func updateUIViewController(_ uiViewController: AlbumVC, context: UIViewControllerRepresentableContext<AlbumController>) {

    }
    
    
}
