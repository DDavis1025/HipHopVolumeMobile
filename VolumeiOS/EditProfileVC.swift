//
//  EditProfileVC.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 5/12/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit

struct EditPFStruct {
    static var photoDidChange:Bool? = false
    
    func updatePhotoBool(newBool: Bool) {
        EditPFStruct.self.photoDidChange = newBool
    }
}

class EditProfileVC: Toolbar, UITextFieldDelegate {
    
    var user_profile = SessionManager.shared.profile
    var imageLoader:DownloadImage?
    var imageView = UIImageView()
    var button = UIButton()
    let userTextField =  UITextField()
    let emailTextField = UITextField()
    let userLabel = UILabel()
    let emailLabel = UILabel()
    var save = UIButton()
    let pictureBool = EditPFStruct()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProfileImage()
        addUserTextField()
        addEmailTextField()
        addEmailLabel()
        addUserLabel()
        addUserConstraints()
        addEmailConstraints()
        addNavButtons()
        view.backgroundColor = UIColor.white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        photoDidUpdate()
    }
    
    func photoDidUpdate() {
    if EditPFStruct.photoDidChange! {
     if let profile = user_profile {
        print("hellur 2")
               GetUsersById(id: profile.sub).getAllPosts {
                   let photo = $0
                   self.imageLoader = DownloadImage()
                   self.imageLoader?.imageDidSet = { [weak self] image in
                       DispatchQueue.main.async {
                           self?.imageView.image = image
                           self?.view?.addSubview(self!.imageView)
                       }
                   }
                   self.imageLoader?.downloadImage(urlString: photo[0].picture!)
                   print("photo \(photo[0].picture)")
               }
         }
      }
    }
    
    
    func setProfileImage() {
        imageLoader = DownloadImage()
        self.imageLoader?.imageDidSet = { [weak self] image in
            self?.imageView.image = image
            print("image \(image)")
            if let imageView = self?.imageView {
                self?.view?.addSubview(imageView)
                self?.setImageContraints()
                self?.addButton()
            }
        }
        imageLoader?.downloadImage(urlString: (user_profile?.picture!.absoluteString)!)
        print("url string \((user_profile?.picture!.absoluteString)!)")
    }
    
    func setImageContraints() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func addButton() {
        button.setTitle("Change Photo", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.titleLabel?.font =  UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        
        button.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5).isActive = true
        
        button.isUserInteractionEnabled = true
        
        button.addTarget(self, action:#selector(buttonClicked), for: .touchUpInside)
        
        
    }
    
    func addUserLabel() {
        userLabel.text = "Username:"
        self.view.addSubview(userLabel)
        
    }
    
    func addEmailLabel() {
        emailLabel.text = "Email:"
        self.view.addSubview(emailLabel)
        
    }
    
    func addUserTextField() {
        
        userTextField.placeholder = "Enter username"
        userTextField.font = UIFont.systemFont(ofSize: 15)
        userTextField.borderStyle = UITextField.BorderStyle.roundedRect
        userTextField.autocorrectionType = UITextAutocorrectionType.no
        userTextField.keyboardType = UIKeyboardType.default
        userTextField.returnKeyType = UIReturnKeyType.done
        userTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        userTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        userTextField.delegate = self
        self.view.addSubview(userTextField)
        
        
    }
    
    func addUserConstraints() {
        userTextField.translatesAutoresizingMaskIntoConstraints = false
        
        userTextField.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20).isActive = true
        userTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        userTextField.leadingAnchor.constraint(equalTo: userLabel.trailingAnchor, constant: 5).isActive = true
        
        userTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        
        userLabel.centerYAnchor.constraint(equalTo: userTextField.centerYAnchor).isActive = true
        
        userLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
    }
    
    
    
    
    
    func addEmailTextField() {
        
        emailTextField.placeholder = "Enter email"
        emailTextField.font = UIFont.systemFont(ofSize: 15)
        emailTextField.borderStyle = UITextField.BorderStyle.roundedRect
        emailTextField.autocorrectionType = UITextAutocorrectionType.no
        emailTextField.keyboardType = UIKeyboardType.default
        emailTextField.returnKeyType = UIReturnKeyType.done
        emailTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        emailTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        emailTextField.delegate = self
        self.view.addSubview(emailTextField)
        
    }
    
    
    func addEmailConstraints() {
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        emailTextField.topAnchor.constraint(equalTo: userTextField.bottomAnchor, constant: 7).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        emailTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        emailTextField.leadingAnchor.constraint(equalTo: emailLabel.trailingAnchor, constant: 5).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emailLabel.centerYAnchor.constraint(equalTo: emailTextField.centerYAnchor).isActive = true
        
        emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
    }
    
    @objc func buttonClicked() {
        print("change photo clicked")
        showImagePickerController()
    }
    
    func addNavButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
    }
    
    
    @objc func cancelTapped(sender: UIBarButtonItem) {
        print("hello")
        navigationController?.popViewController(animated: true)
//        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func doneTapped(sender: UIBarButtonItem) {
      userPhotoUpload()
    }
    
    
    func userPhotoUpload() {
        var component = URLComponents()
        component.scheme = "http"
        component.host = "localhost"
        component.port = 8000
        component.path = "/upload"
        
        var imageToServer = ImageToServer()
        let user_id = user_profile?.sub
        if let user_id = user_id {
            imageToServer.imageUploadRequest(imageView: imageView, uploadUrl: component.url!, param: ["user_id":user_id]) {
                let getPhoto = GETUserPhotoByID(id: self.user_profile!.sub)
                getPhoto.getPhotoById {
                    var component2 = URLComponents()
                    component2.scheme = "http"
                    component2.host = "127.0.0.1"
                    component2.port = 8000
                    let photo = $0
                    if let photo_path = photo[0].path {
                    component2.path = "/\(photo_path)"
                    }
                    let updateUser = UpdateUserInfo()
                    updateUser.updateUserInfo(parameters: ["picture": component2.url!.absoluteString], user_id: self.user_profile!.sub)
                    
                    self.pictureBool.updatePhotoBool(newBool: true)
                }
            }
        }
        
    }
    
    
    
    
    
}


extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
}

