//
//  CommentVC.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 6/13/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit

struct CommentStruct {
    static var isSelected:Bool? = false
    static var parent_id:String?
    
    func updateIsSelected(newBool: Bool) {
        CommentStruct.self.isSelected = newBool
    }
    
    func updateParentId(newString: String) {
        CommentStruct.self.parent_id = newString
    }
    
    
}

class CommentVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, UpdateTableView {
    func updateTableView(bool: Bool) {
         if bool == true {
               print("it worked")
//               self.myTableView.reloadData()
            UIView.performWithoutAnimation {
               self.myTableView.beginUpdates()
               self.myTableView.endUpdates()
            }
        }
    }
    
    
    private var myTableView:UITableView!
    var textField = UITextField()
    var bottomConstraint:NSLayoutConstraint?
    var profile = SessionManager.shared.profile
    var username:String?
    var imageLoader:DownloadImage?
    var comments:[Comments] = []
    var sub_comments:[Comments] = []
    var textViewHeight = CGFloat()
    let countLabel = UILabel()
    let textViewView = UIView()
    let sendBtn = UIButton()
    var tap: UITapGestureRecognizer?
    let comment = CommentStruct()
    var parent_id:String?
    var reply:Bool = false
    
    lazy var textView:UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.text = "Enter Comment"
        tv.textColor = UIColor.lightGray
        tv.sizeToFit()
        tv.returnKeyType = UIReturnKeyType.default
        tv.layer.cornerRadius = 4
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.borderWidth = 0.5
        tv.keyboardType = UIKeyboardType.default
        tv.backgroundColor = UIColor.white
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
        view.addSubview(self.textViewView)
        view.bringSubviewToFront(self.textViewView)
        textViewView.addSubview(textView)
        textViewView.addSubview(sendBtn)
        sendBtn.isEnabled = false
        createViewForTextView()
        setupTextViewConstraints()
        createSendButton()
//        setupCountLabel()
        addTableView()
//        view.bringSubviewToFront(countLabel)
        loadComments()
        
        
        
//        tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//
//        if let tap = tap {
//        view.addGestureRecognizer(tap)
//        }
//        tap?.isEnabled = false
//
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func getUser() {
        print("getUser")
        if let id = profile?.sub {
            GetUsersById(id: id).getAllPosts {
                print("gotUser $0 \($0)")
                self.username = $0[0].username
                print("got User \(self.username)")
            }
        }
    }
    
   func setupCountLabel() {
        countLabel.textColor = UIColor.black
        countLabel.textAlignment = .center
        countLabel.layer.cornerRadius = 5
        countLabel.layer.borderWidth = 1.0
        countLabel.backgroundColor = UIColor.white
        countLabel.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(countLabel)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        countLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        countLabel.bottomAnchor.constraint(equalTo: textView.topAnchor).isActive = true
        countLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if CommentStruct.isSelected! && reply {
            textView.text = nil
            textView.textColor = UIColor.black
            reply = false
        }
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        countLabel.text = "\(textView.text.count)"
        return textView.text.count + (text.count - range.length) <= 250
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
            print("did begin editing")
            textView.text = nil
            textView.textColor = UIColor.black
    }
    
    
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            sendBtn.isEnabled = false
        } else {
            sendBtn.isEnabled = true
        }
    }
    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = "Enter Comment"
//            textView.textColor = UIColor.lightGray
//        }
//    }
//

    
    @objc func dismissKeyboard() {
        textView.resignFirstResponder()
        tap?.isEnabled = false
        print("dismissKeyboard")
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
        let getComments = GETComments(id: "2d44a588-e47a-43c5-bd16-94e7073e4e14", path: "comments")
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
    

    
    func setupTextViewConstraints() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        textView.topAnchor.constraint(equalTo: textViewView.topAnchor).isActive = true
        var frame = self.textView.frame
        frame.size.height = self.textView.contentSize.height
        self.textView.frame = frame
                
}
    
    func createViewForTextView() {
        textViewView.backgroundColor = UIColor.white
        textViewView.layer.borderColor = UIColor.lightGray.cgColor
        textViewView.layer.borderWidth = 1.0
        textViewView.translatesAutoresizingMaskIntoConstraints = false
        textViewView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        textViewView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        textViewView.heightAnchor.constraint(equalTo: textView.heightAnchor, constant: 50).isActive = true
        
        
        bottomConstraint = textViewView.bottomAnchor.constraint(equalTo: (self.view.safeAreaLayoutGuide.bottomAnchor), constant: 0)
        bottomConstraint?.isActive = true
    }
    
    func createSendButton() {
        let btnConfiguration = UIImage.SymbolConfiguration(scale: .medium)
        let btnSymbolImage = UIImage(systemName: "arrowshape.turn.up.right.fill", withConfiguration: btnConfiguration)
        sendBtn.setImage(btnSymbolImage, for: .normal)
        sendBtn.translatesAutoresizingMaskIntoConstraints = false
        sendBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        sendBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        sendBtn.trailingAnchor.constraint(equalTo: textViewView.trailingAnchor, constant: -8).isActive = true
        sendBtn.bottomAnchor.constraint(equalTo: self.textViewView.bottomAnchor, constant: -15).isActive = true
        sendBtn.addTarget(self, action: #selector(sendComment), for: .touchUpInside)
        
    }
    
    @objc func sendComment() {
        if CommentStruct.isSelected == true {
          sendSubComment()
          print("sub comment sendComment")
        } else {
          ("main comment sendComment")
          performActionSend()
        }
        view.endEditing(true)
    }

    func sendSubComment() {
        if let text = textView.text,
        let username = username,
        let user_picture = profile?.picture,
        let user_id = profile?.sub,
        let parent_id = parent_id {
            print("got info")
            let comment = Comment(post_id: "2d44a588-e47a-43c5-bd16-94e7073e4e14", username: username, user_picture: user_picture.absoluteString, user_id: user_id, text: text, parent_id: parent_id)
            
            let postRequest = CommentPostRequest(endpoint: "sub_comment")
            postRequest.save(comment) { (result) in
                switch result {
                case .success(let comment):
                    print("the following comment has been sent: \(comment)")
                    DispatchQueue.main.async {
                    self.myTableView.reloadData()
                    UIView.performWithoutAnimation {
                       self.myTableView.beginUpdates()
                       self.myTableView.endUpdates()
                    }
                    }
                case .failure(let error):
                    print("An error occurred: \(error)")
                }
            }
        } else {
            print("text \(textView.text)")
            print("username \(username)")
            print("user_picture \(profile?.picture)")
            print("user_id \(profile?.sub)")
            print("parent_id \(parent_id)")
        }
        print("sub comment send tapped")
        textView.text = ""
    }
    
    func performActionSend() {
        if let text = textView.text,
        let username = username,
        let user_picture = profile?.picture,
        let user_id = profile?.sub {
            print("got info")
            let comment = Comment(post_id: "2d44a588-e47a-43c5-bd16-94e7073e4e14", username: username, user_picture: user_picture.absoluteString, user_id: user_id, text: text, parent_id: nil)
            
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
        } else {
            print("text \(textView.text)")
            print("username \(username)")
            print("user_picture \(profile?.picture)")
            print("user_id \(profile?.sub)")
        }
        print("main comment send tapped")
        textView.text = ""
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !textView.isFirstResponder {
           textView.becomeFirstResponder()
           tableView.deselectRow(at: indexPath, animated: true)
           comment.updateIsSelected(newBool: true)
           parent_id = comments[indexPath.row].id
           reply = true
//           tap?.isEnabled = true

            textView.text = nil
           // If updated text view will be empty, add the placeholder
           // and set the cursor to the beginning of the text view
            if textView.text.isEmpty {

               textView.text = "Reply"
               textView.textColor = UIColor.lightGray

               textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
           }

           print("didSelect isFirst \(tap?.isEnabled)")
        } else {
            textView.text = nil
            textView.resignFirstResponder()
            if textView.text.isEmpty {

                textView.text = "Enter Comment"
                textView.textColor = UIColor.lightGray
            }

            tableView.deselectRow(at: indexPath, animated: false)
            comment.updateIsSelected(newBool: false)
        }
//           tap?.isEnabled = true
        print("didSelect \(tap?.isEnabled) + \(textView.isFirstResponder)")
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath) as! CommentCell
        cell.delegate = self
        let comment = comments[indexPath.row]
        cell.set(comment: comment)
        if let id = comment.id {
        cell.parent_id = id
        }
        return cell
    }
    
    
}

