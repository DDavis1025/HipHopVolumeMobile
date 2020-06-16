//
//  CommentVC.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 6/13/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit

class CommentVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, HeightForTextView, UITextViewDelegate {
    func heightOfTextView(height: CGFloat) {
        print("commentVC delegate function called")
        textViewHeight = height
        self.myTableView.beginUpdates()
        self.myTableView.endUpdates()
    }
    
    private var myTableView:UITableView!
    var textField = UITextField()
    var bottomConstraint:NSLayoutConstraint?
    var profile = SessionManager.shared.profile
    var username:String?
    var imageLoader:DownloadImage?
    var comments:[Comments] = []
    var textViewHeight = CGFloat()
    let countLabel = UILabel()
    
    lazy var textView:UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.sizeToFit()
        tv.returnKeyType = UIReturnKeyType.send
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.borderWidth = 0.5
        tv.keyboardType = UIKeyboardType.default
        tv.backgroundColor = UIColor.yellow
        tv.textContainer.maximumNumberOfLines = 0
        tv.textContainer.lineBreakMode = .byCharWrapping
        tv.font = UIFont(name: "GillSans", size: 18)
        return tv
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        navigationController?.isToolbarHidden = true
        getUser()
        self.textView.delegate = self
//        addTextField()
        view.addSubview(self.textView)
        setupTextViewConstraints()
        setupCountLabel()
        addTableView()
        loadComments()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func getUser() {
        if let id = profile?.sub {
            GetUsersById(id: id).getAllPosts {
                self.username = $0[0].username
            }
        }
    }
    
    func setupCountLabel() {
//        countLabel.backgroundColor = .clear
//        countLabel.layer.cornerRadius = 2
//        countLabel.layer.borderWidth = 1
//        countLabel.layer.borderColor = UIColor.lightGray.cgColor
        countLabel.text = "Hello World"
        countLabel.textColor = UIColor.black
        view.addSubview(countLabel)
        view.bringSubviewToFront(countLabel)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        countLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        countLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        countLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
    }
    
    func setupTextViewConstraints() {
           textView.translatesAutoresizingMaskIntoConstraints = false
           textView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
           textView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
           bottomConstraint = textView.bottomAnchor.constraint(equalTo: (view?.safeAreaLayoutGuide.bottomAnchor)!, constant: 0)
           bottomConstraint?.isActive = true
            var frame = self.textView.frame
            frame.size.height = self.textView.contentSize.height
            self.textView.frame = frame
            
        }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        countLabel.text = "\(textView.text.count)"
        return textView.text.count + (text.count - range.length) <= 250
    }
    
//    func setupTextViewConstraints() {
//        textView.translatesAutoresizingMaskIntoConstraints = true
////        var frame = self.textView.frame
////        frame.size.height = self.textView.contentSize.height
////        self.textView.frame = frame
//
////        textView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//
//        textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//
//        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
////        textView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//
////        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//
//        bottomConstraint = textView.bottomAnchor.constraint(equalTo: (view?.safeAreaLayoutGuide.bottomAnchor)!, constant: 0)
//        bottomConstraint?.isActive = true
////        bottomConstraint = textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
////        bottomConstraint?.isActive = true
//    }
//
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @objc func handleKeyBoardNotification(notification:NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            let isKeyBoardShowing = notification.name == UIResponder.keyboardWillShowNotification
            bottomConstraint?.constant = isKeyBoardShowing ? -keyboardFrame.height : 0

            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                
            }
        }
    }
    
    func loadComments() {
        let getComments = GETCommentsByPostId(id: "2d44a588-e47a-43c5-bd16-94e7073e4e14")
        getComments.getAllById {
            self.comments = $0
            DispatchQueue.main.async {
                self.myTableView.reloadData()
            }
        }
    }
    
    func addTableView() {
        
        self.myTableView = UITableView()
        
        
        self.myTableView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.myTableView.frame.size.height = self.view.frame.height
        //
        self.myTableView.frame.size.width = self.view.frame.width
        
        
        self.myTableView.register(CommentCell.self, forCellReuseIdentifier: "MyCell")
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        self.myTableView.isScrollEnabled = true
        
        myTableView.delaysContentTouches = false
        self.view.addSubview(self.myTableView)
        
    
        self.myTableView?.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        self.myTableView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        self.myTableView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        self.myTableView.bottomAnchor.constraint(equalTo: self.textView.topAnchor).isActive = true
        
        self.myTableView.estimatedRowHeight = 80
        self.myTableView.rowHeight = UITableView.automaticDimension
        
        
        myTableView.layoutMargins = UIEdgeInsets.zero
        myTableView.separatorInset = UIEdgeInsets.zero
        
        
    }
    
    func addTextField() {
        textField.placeholder = "Enter Comment"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.send
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 0.5
        textField.delegate = self
        self.view.addSubview(textField)
        
        textFieldContraints()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()  //if desired
        performActionSend()
        return true
    }

    func performActionSend() {
        if let text = textField.text,
        let username = username,
        let user_picture = profile?.picture,
        let user_id = profile?.sub {
            print("got info")
            let comment = Comment(post_id: "2d44a588-e47a-43c5-bd16-94e7073e4e14", username: username, user_picture: user_picture.absoluteString, user_id: user_id, text: text, parent_id: "")
            
            let postRequest = CommentPostRequest(endpoint: "comment")
            postRequest.save(comment) { (result) in
                switch result {
                case .success(let comment):
                    print("the following comment has been sent: \(comment)")
                    self.loadComments()
                case .failure(let error):
                    print("An error occurred: \(error)")
                }
            }
        } 
        print("send tapped")
//        textField.text = ""
    }
    
//    self.post_id = post_id
//    self.id = id
//    self.username = username
//    self.user_picture = user_picture
//    self.user_id = user_id
//    self.text = text
//    self.parent_id = parent_id
    
    func textFieldContraints() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        textField.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
        
        bottomConstraint = textField.bottomAnchor.constraint(equalTo: (view?.safeAreaLayoutGuide.bottomAnchor)!, constant: 0)
        bottomConstraint?.isActive = true
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textField.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath) as! CommentCell
        let comment = comments[indexPath.row]
        cell.myDelegate = self
        cell.set(comment: comment)
        
        return cell
    }
    
    
}

