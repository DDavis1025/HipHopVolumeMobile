//
//  MainView.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 4/24/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

//
//  MainView.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 4/24/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//
import Foundation
import UIKit
import SwiftUI
import Auth0
    

class HomeViewController: Toolbar, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let videoId = "videoId"
    let tracksId = "tracksId"
    var albumVC:AlbumVC?
    var userAndFollowVC:UserPfAndFollow?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuBar()
        setupCollectionView()
        
        navigationController?.isToolbarHidden = false
        
        let logout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
               
        let profile = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(addTapped))
                          
        let whoToFollow = UIBarButtonItem(title: "toFollow", style: .plain, target: self, action: #selector(toFollowTapped))
        

        navigationItem.leftBarButtonItem = profile
        navigationItem.rightBarButtonItem = whoToFollow
        navigationItem.rightBarButtonItem = logout
         
         self.navigationController?.isToolbarHidden = false
         self.navigationController?.isNavigationBarHidden = false

//        auth0()

    }
    
    func pushToAlbumVC(post: Post) {
        albumVC = AlbumVC(post: post)
        navigationController?.pushViewController(self.albumVC!, animated: true)
    }
    
    @objc func addTapped() {
            let profileVC = ProfileViewController()
            let profileView = ProfileVC()
            self.navigationController?.pushViewController(profileView, animated: true)
        }
        
    @objc func toFollowTapped() {
        let toFollowVC = WhoToFollowVC()
        self.navigationController?.pushViewController(toFollowVC, animated: true)
    }
     
     @objc func logoutTapped() {
             let authVC = AuthVC()
             SessionManager.shared.logout { (error) in
                 guard error == nil else {
                 // Handle error
                 print("Error: \(error)")
                 return
             }
         }
             print("Session manager credentials \(SessionManager.shared.credentials)")
             self.navigationController?.popToRootViewController(animated: true)
             self.navigationController?.isToolbarHidden = true
             self.navigationController?.isNavigationBarHidden = true
         }

    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    
    func setupCollectionView() {
        
        view.addSubview(collectionView)
        
        view.bringSubviewToFront(collectionView)
        
        collectionView.isPagingEnabled = true
//        collectionView.backgroundColor = UIColor.gray
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: menuBar.bottomAnchor).isActive = true
        
        
        collectionView.register(AlbumCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(TracksCell.self, forCellWithReuseIdentifier: tracksId)
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: videoId)
        
        
    }
    
    lazy var menuBar:MenuBar = {
        let mb = MenuBar()
        mb.homeVC = self
        return mb
    }()
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        self.menuBar.translatesAutoresizingMaskIntoConstraints = false
        self.menuBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        self.menuBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        self.menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.menuBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.menuBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.menuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 3
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = NSIndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath as IndexPath, animated: true, scrollPosition: [])
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = NSIndexPath(item: menuIndex, section: 0)
        collectionView.scrollToItem(at: indexPath as IndexPath, at: [], animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        if indexPath.item == 1 {
            let tracksCell = collectionView.dequeueReusableCell(withReuseIdentifier: tracksId, for: indexPath) as! TracksCell
            tracksCell.parent = self
            return tracksCell
        } else if indexPath.item == 2 {
            let videoCell = collectionView.dequeueReusableCell(withReuseIdentifier: videoId, for: indexPath) as! VideoCell
            videoCell.parent = self
            return videoCell
        }
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AlbumCell
         cell.parent = self
        
         let colors: [UIColor] = [.yellow, .orange, .red]
         cell.backgroundColor = colors[indexPath.item]
         return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.safeAreaLayoutGuide.layoutFrame.size.width, height: view.safeAreaLayoutGuide.layoutFrame.size.height)
    }
    
    
    
    
    

}
