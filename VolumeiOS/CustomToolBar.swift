//
//  CustomToolBar.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 8/18/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

//import Foundation
//import UIKit
//import SwiftUI
//
//
//class CustomToolBar: UIToolbar {
//    
//    var playBtn = UIBarButtonItem()
//    var pauseBtn = UIBarButtonItem()
//    var albumTrackVCPressed:Bool?
////    var button:UIButton?
//
//    var atVCLoaded:Bool?
//    
//    
//
////    let albumTrackVC = AlbumTrackVC()
//    
//    init() {
//        barTintColor = UIColor.darkGray
//           isTranslucent = false
//        
//        
//        self.playBtn = UIBarButtonItem(barButtonSystemItem: .play , target: self, action: #selector(playBtnAction(sender:)))
//        self.pauseBtn = UIBarButtonItem(barButtonSystemItem: .pause , target: self, action: #selector(pauseBtnAction(sender:)))
//        
//        playBtn.tintColor = UIColor.white
//        pauseBtn.tintColor = UIColor.white
//        
//        setItems([playBtn, pauseBtn], animated: false)
//        
//        addGesture()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//
//    
//    func addGesture() {
//        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
//        addGestureRecognizer(gesture)
//    }
//    
//    
//    @objc func playBtnAction(sender: UIBarButtonItem)
//{
//
//    if ModelClass.playing! || TrackPlay.playing! {
//     player!.play()
//     print("play")
//    }
//}
//
//    @objc func pauseBtnAction(sender: UIBarButtonItem)
//{
//    if ModelClass.playing! || TrackPlay.playing! {
//      print("pause")
//      player!.pause()
//    }
//}
//    
//    
//    @objc func checkAction(sender : UITapGestureRecognizer) {
//        let albumTrackVC = AlbumTrackVC()
//        let trackVC = TrackPlayVC()
//        print("toolbar track play view \(TrackPlay.viewAppeared)")
//        if ModelClass.viewAppeared! {
//            let atVC = UINavigationController(rootViewController: albumTrackVC)
//            atVC.modalPresentationStyle = .fullScreen
//            self.present(atVC, animated: true, completion: nil)
//        } else if TrackPlay.viewAppeared! {
//            print("track view appeared")
//            let modalVC = UINavigationController(rootViewController: trackVC)
//            modalVC.modalPresentationStyle = .fullScreen
//            self.present(modalVC, animated: true, completion: nil)
////            self.present(trackVC, animated: true, completion: nil)
//        }
//
//}
//
//}
//
