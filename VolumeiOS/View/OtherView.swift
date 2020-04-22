
    import Foundation

    import UIKit
    import SwiftUI
    import AVFoundation
    import Auth0


//protocol MyProtocol: class {
//    func setResultOfBusinessLogic(valueSent: Bool?)
//}



class OtherView: UIViewController {
    
    
    
        var playing:Bool? = false

        let secondViewController = UIHostingController(rootView: ContentView())
    
    
        static var shared = OtherView()
        
        
        let globalAudioVC = GlobalAudio()
//    
//        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
//            self.atVC.delegate = self
//            atVC.passingVar = "passedVar"
//            print("mainVC Del \(self.atVC.delegate)")
            print("This is a Git tutorial")
            
            view.backgroundColor = UIColor.white
//            view.bringSubviewToFront(globalAudioVC.view)
            view.isUserInteractionEnabled = true
            
           let profile = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(addTapped))
            
           let whoToFollow = UIBarButtonItem(title: "toFollow", style: .plain, target: self, action: #selector(toFollowTapped))

            navigationItem.leftBarButtonItem = profile
            navigationItem.rightBarButtonItem = whoToFollow
        
            
            secondViewController.view.isUserInteractionEnabled = true
            globalAudioVC.view.isUserInteractionEnabled = true
            
            
            addSecondVC()
            addglobalAudioVC()
            auth0()

            
        }
    func auth0() {
        Auth0
        .webAuth()
        .scope("openid offline_access profile")
        .audience("https://dev-owihjaep.auth0.com/userinfo")
        .start {
            switch $0 {
            case .failure(let error):
                print("Error: \(error)")
            case .success(let credentials):
                print(credentials.accessToken)
                if(!SessionManager.shared.store(credentials: credentials)) {
                    print("Failed to store credentials")
                } else {
                    SessionManager.shared.retrieveProfile { error in
                        DispatchQueue.main.async {
                            guard error == nil else {
                                print("Failed to retrieve profile: \(String(describing: error))")
                                return
                        }
                      }
                    }
                }
            }
        }
    }
    
        
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        print("Playing \(playing)")
     }

     override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
        print("Playing \(playing)")
     }
    
    func setResultOfBusinessLogic(valueSent: Bool?) {
         self.playing = valueSent
         print("Value \(valueSent)")
         print("Yolo")
    }
    
    
        func addSecondVC() {
            addChild(secondViewController)
            view.addSubview(secondViewController.view)
            secondViewController.didMove(toParent: self)
            setSecondChildVCConstraints()
        }
        
        func addglobalAudioVC() {
            addChild(globalAudioVC)
            view.addSubview(globalAudioVC.view)
            globalAudioVC.didMove(toParent: self)
            setglobalAudioVCConstraints()
        }
        
        
        func setSecondChildVCConstraints() {
        secondViewController.view.translatesAutoresizingMaskIntoConstraints = false
            secondViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
            
            secondViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

            secondViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

            secondViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            
        }

//    override func willMove(toParent parent: UIViewController?){
//        super.willMove(toParent: OtherView())
//        if parent == nil {
//            self.navigationController?.isToolbarHidden = false
//            print("hello")
//        }
//    }
        
        
        func setglobalAudioVCConstraints() {
        globalAudioVC.view.translatesAutoresizingMaskIntoConstraints = false

            globalAudioVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
             
            
          globalAudioVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

          globalAudioVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        

        globalAudioVC.view.heightAnchor.constraint(equalToConstant: 60).isActive = true


               }
        
        
        
    @objc func addTapped() {
        let profileVC = ProfileViewController()
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc func toFollowTapped() {
        let toFollowVC = WhoToFollowVC()
        self.navigationController?.pushViewController(toFollowVC, animated: true)
    }
       
        
        
    }



    
    
    
   



