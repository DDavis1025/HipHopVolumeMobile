//
//  GlobalAudio.swift
//  Test
//
//  Created by Dillon Davis on 3/31/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation

import UIKit
import SwiftUI
import AVFoundation
import Auth0

class GlobalAudio: UIViewController {
    
    

    var toolBar = UIToolbar()
    var playBtn = UIBarButtonItem()
    var pauseBtn = UIBarButtonItem()
    var playing:Bool? = false
    var albumTrackVCPressed:Bool?
//    var button:UIButton?

    static var shared = GlobalAudio()
    var atVCLoaded:Bool?
    
    

//    let albumTrackVC = AlbumTrackVC()
    

override func viewDidLoad()
{
    super.viewDidLoad()
    
        toolBar.frame.size.height = 20
        toolBar.frame.size.width = self.view.frame.width
//        toolBar.barStyle = UIBarStyle.RawValue
        toolBar.isTranslucent = false
        toolBar.backgroundColor = UIColor.darkGray
        toolBar.barTintColor = UIColor.darkGray
        toolBar.sizeToFit()
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        toolBar.addGestureRecognizer(gesture)

//        toolBar.isUserInteractionEnabled = true
        self.playBtn = UIBarButtonItem(barButtonSystemItem: .play , target: self, action: #selector(playBtnAction(sender:)))
        self.pauseBtn = UIBarButtonItem(barButtonSystemItem: .pause , target: self, action: #selector(pauseBtnAction(sender:)))
    
        playBtn.tintColor = UIColor.white
        pauseBtn.tintColor = UIColor.white

        toolBar.setItems([playBtn, pauseBtn], animated: false)
    
//               let profile = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(addTapped))
//               
//              let whoToFollow = UIBarButtonItem(title: "toFollow", style: .plain, target: self, action: #selector(toFollowTapped))

//               navigationItem.leftBarButtonItem = profile
//               navigationItem.rightBarButtonItem = whoToFollow
   
//        addSecondVC()
        self.view.addSubview(toolBar)
//        setglobalAudioVCConstraints()
//        self.view.addSubview(button)
    
        view.isUserInteractionEnabled = true
//        auth0()
        

}
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        setupLayout()

    }
    


override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}

    
            
    
    @objc func playBtnAction(sender: UIBarButtonItem)
{

    if ModelClass.playing! {
     player!.play()
     print("play")
    }
}

    @objc func pauseBtnAction(sender: UIBarButtonItem)
{
//    print(AlbumTrackVC.shared.playing!)
    if ModelClass.playing! {
      print("pause")
      player!.pause()
    }
}
    
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
         let albumTrackVC = AlbumTrackVC()
//        playing = true
//        player!.pause()
         
//        print("toolbar clicked")
//        print(albumTrackVCPressed)
        if ModelClass.playing! {
        self.present(albumTrackVC, animated: true, completion: nil)
//            player?.play()
        }
//    }

}

}


//struct AudioController: UIViewControllerRepresentable {
//    func makeUIViewController(context: UIViewControllerRepresentableContext<AudioController>) -> GlobalAudio {
//        return GlobalAudio()
//    }
//
//    func updateUIViewController(_ uiViewController: GlobalAudio, context: UIViewControllerRepresentableContext<AudioController>) {
//
//    }
//
//
//}

