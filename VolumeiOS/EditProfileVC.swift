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

class EditProfileVC: Toolbar, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
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
    let updateUser = UpdateUserInfo()
    var pictureAdded:Bool = false
    var emailWarning:UILabel?
    var usernameWarning:UILabel?
    var dispatchGroup = DispatchGroup()
    var photo:[UserPhoto]?
    var imagePH = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePlaceHolder()
        addButton()
        setProfileImage()
        addUserTextField()
        usernameTaken()
        addEmailTextField()
        addEmailLabel()
        addUserLabel()
        addUserConstraints()
        addEmailConstraints()
        addNavButtons()
        emailTaken()
        
        dispatchGroup.enter()
        dispatchGroup.enter()
        dispatchGroup.enter()
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
                self?.imagePH.isHidden = true
            }
        }
        imageLoader?.downloadImage(urlString: (user_profile?.picture!.absoluteString)!)
        print("url string \((user_profile?.picture!.absoluteString)!)")
    }
    
    func imagePlaceHolder() {
        imageView.image = UIImage(named: "profile-placeholder-user")
        view.addSubview(imageView)
        setImageContraints()
    }
    
    func setImageContraints() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setImagePHContraints() {
        self.imagePH.translatesAutoresizingMaskIntoConstraints = false
        self.imagePH.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        self.imagePH.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.imagePH.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.imagePH.heightAnchor.constraint(equalToConstant: 150).isActive = true
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
        
        emailTextField.topAnchor.constraint(equalTo: usernameWarning!.bottomAnchor, constant: 7).isActive = true
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
        if pictureAdded {
        userPhotoUpload()
        } else {
            dispatchGroup.leave()
            print("dispatch leave1")
        }
        updateEmail()
        updateUsername()
        
        self.updateUserInfo()
    }
    
    
    func userPhotoUpload() {
        var component = URLComponents()
        component.scheme = "http"
        component.host = "localhost"
        component.port = 8000
        component.path = "/upload"
        let editPF = EditPFStruct()
        let imageToServer = ImageToServer()
        let user_id = user_profile?.sub
        if let user_id = user_id {
            imageToServer.imageUploadRequest(imageView: imageView, uploadUrl: component.url!, param: ["user_id":user_id]) {
                let getPhoto = GETUserPhotoByID(id: self.user_profile!.sub)
                getPhoto.getPhotoById {
                    var component2 = URLComponents()
                    component2.scheme = "http"
                    component2.host = "127.0.0.1"
                    component2.port = 8000
                    self.photo = $0
                    if let photo_path = self.photo![0].path {
                    component2.path = "/\(photo_path)"
                    }
                    self.updateUser.updateUserInfo(parameters: ["picture": component2.url!.absoluteString], user_id: self.user_profile!.sub)
                    editPF.updatePhotoBool(newBool: true)
                    self.dispatchGroup.leave()
//
                }
            }
        }
        }
        
    
    
    func updateEmail() {
        var emailIsValid = isValidEmail(emailTextField.text!)
        
        if emailTextField.text != "" {
            print("email text \(emailTextField.text)")
            emailIsValid = isValidEmail(emailTextField.text!)
            if emailIsValid == false {
               print("email is not valid")
               self.emailWarning?.text = "⚠ Enter a valid email address"
               self.emailWarning?.isHidden = false
            }
            let emailValidation = EmailValidation()
            emailValidation.getEmail(email: emailTextField.text!.lowercased()) {
                print("getEmail")
                 if $0.count > 0 {
                    print("email already taken \($0)")
                    self.emailWarning?.isHidden = false
                    self.emailWarning?.text = "⚠ This email is already taken"
                 } else {
                    print("email accepted \($0)")
                    self.emailWarning?.isHidden = true
                    self.dispatchGroup.leave()
                    print("dispatch leave2")
//                    self.updateUser.updateUserInfo(parameters: ["email": self.emailTextField.text!], user_id: self.user_profile!.sub)
//                    print("dismissed")
                }
            }
        } else {
            emailWarning?.isHidden = true
            self.dispatchGroup.leave()
            print("dispatch leave2 else")
        }
        
    }
    
    func updateUsername() {
        if userTextField.text != "" {
            let usernameValidation = UsernameValidation()
            usernameValidation.getUsername(username: userTextField.text!) {
                if $0.count > 0 {
                    print("$0 username \($0)")
                    self.usernameWarning?.isHidden = false
                    print("$0.count > 0 username")
                } else {
                    self.usernameWarning?.isHidden = true
                    self.dispatchGroup.leave()
                    print("username accepted \($0)")
                    print("dispatch leave3")
//                    self.updateUser.updateUserInfo(parameters: ["username": self.userTextField.text!], user_id: self.user_profile!.sub)
//                    print("dismissed")
                    }
                }
        } else {
            self.dispatchGroup.leave()
            print("dispatch leave3 else")
         }
    }
    
    func updateUserInfo() {
    
        dispatchGroup.notify(queue: .main) {
        print("updated")
        if self.userTextField.text != "" {
        print("username updated")
        self.updateUser.updateUserInfo(parameters: ["username": self.userTextField.text!], user_id: self.user_profile!.sub)
        } else {
            print("false username update")
            }
        
        if self.emailTextField.text != "" {
        print("email updated")
        self.updateUser.updateUserInfo(parameters: ["email": self.emailTextField.text!], user_id: self.user_profile!.sub)
        } else {
            print("false email update")
        }
      }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == userTextField {
            self.usernameWarning?.isHidden = true
        }
        if textField == emailTextField {
            self.emailWarning?.isHidden = true
        }
    }
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    func usernameTaken() {
        usernameWarning = UILabel()
        usernameWarning?.text = "⚠ This username is already taken"
        usernameWarning?.textColor = UIColor.red
        usernameWarning?.isHidden = true
        view.addSubview(usernameWarning!)
        usernameWarningConstraints()
    }
    
    func usernameWarningConstraints() {
        usernameWarning?.translatesAutoresizingMaskIntoConstraints = false
        
        usernameWarning?.topAnchor.constraint(equalTo: userTextField.bottomAnchor, constant: 7).isActive = true

        usernameWarning?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        usernameWarning?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    
    func emailTaken() {
        emailWarning = UILabel()
        emailWarning?.text = "⚠ This email is already taken"
        emailWarning?.textColor = UIColor.red
        emailWarning?.isHidden = true
        view.addSubview(emailWarning!)
        emailWarningConstraints()
    }
    
    func emailWarningConstraints() {
        emailWarning?.translatesAutoresizingMaskIntoConstraints = false
        
        emailWarning?.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 7).isActive = true

        emailWarning?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        emailWarning?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
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
            pictureAdded = true
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = originalImage
            pictureAdded = true
        }
        dismiss(animated: true, completion: nil)
    }
}

