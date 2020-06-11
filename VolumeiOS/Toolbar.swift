//
//  Toolbar.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 4/22/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI


class Toolbar: UIViewController {
    
    var playBtn = UIBarButtonItem()
    var pauseBtn = UIBarButtonItem()
    var albumTrackVCPressed:Bool?
//    var button:UIButton?

    var atVCLoaded:Bool?
    
    

//    let albumTrackVC = AlbumTrackVC()
    

override func viewDidLoad()
{
    super.viewDidLoad()
    
        navigationController?.setToolbarHidden(false, animated: false)
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
         navigationController?.toolbar.addGestureRecognizer(gesture)
         navigationController?.toolbar.barTintColor = UIColor.darkGray
         navigationController?.toolbar.isTranslucent = false
         self.extendedLayoutIncludesOpaqueBars = true

//        toolBar.isUserInteractionEnabled = true
        self.playBtn = UIBarButtonItem(barButtonSystemItem: .play , target: self, action: #selector(playBtnAction(sender:)))
        self.pauseBtn = UIBarButtonItem(barButtonSystemItem: .pause , target: self, action: #selector(pauseBtnAction(sender:)))
    
        playBtn.tintColor = UIColor.white
        pauseBtn.tintColor = UIColor.white

        toolbarItems = [playBtn, pauseBtn]
    
        view.isUserInteractionEnabled = true

}
    
    
    
            
    
    @objc func playBtnAction(sender: UIBarButtonItem)
{

    if ModelClass.playing! || TrackPlay.playing! {
     player!.play()
     print("play")
    }
}

    @objc func pauseBtnAction(sender: UIBarButtonItem)
{
    if ModelClass.playing! || TrackPlay.playing! {
      print("pause")
      player!.pause()
    }
}
    
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        let albumTrackVC = AlbumTrackVC()
        let trackVC = TrackPlayVC()
        
        if ModelClass.viewAppeared! {
            self.present(albumTrackVC, animated: true, completion: nil)
        } else if TrackPlay.viewAppeared! {
            print("track view appeared")
            let modalVC = UINavigationController(rootViewController: trackVC)

            self.present(modalVC, animated: true, completion: nil)
//            self.present(trackVC, animated: true, completion: nil)
        }

}

}


//struct ToolbarController: UIViewControllerRepresentable {
//    func makeUIViewController(context: UIViewControllerRepresentableContext<ToolbarController>) -> Toolbar {
//        return Toolbar()
//    }
//
//    func updateUIViewController(_ uiViewController: Toolbar, context: UIViewControllerRepresentableContext<ToolbarController>) {
//
//    }
//
//
//}
