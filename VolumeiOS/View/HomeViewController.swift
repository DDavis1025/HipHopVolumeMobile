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
    

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuBar()
        setupCollectionView()
//        auth0()

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
        
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
//        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
//        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        
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
        self.menuBar.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        self.menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.menuBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
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
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
         let colors: [UIColor] = [.yellow, .orange, .red]
         cell.backgroundColor = colors[indexPath.item]
         return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    
    
    
    

}
