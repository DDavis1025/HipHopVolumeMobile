import Foundation
import UIKit
import Combine

protocol UpdateTableView: class {
    func updateTableView(bool: Bool)
}

class CommentView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        sizeToFit()
        addSubview(textView)
        addSubview(user_image)
        addSubview(username)
        setImageConstraints()
        setUsernameConstraints()
        textViewContstraints()
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var textView:UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.sizeToFit()
        tv.backgroundColor = UIColor.lightGray
        tv.textContainer.maximumNumberOfLines = 0
        tv.textContainer.lineBreakMode = .byCharWrapping
        tv.font = UIFont(name: "GillSans", size: 18)
        return tv
    }()
    
    lazy var user_image: UIImageView = {
        let image = UIImageView()
        
        return image
    }()
    
    lazy var username:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    func setImageConstraints() {
        user_image.translatesAutoresizingMaskIntoConstraints = false
        user_image.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        user_image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        user_image.heightAnchor.constraint(equalToConstant: 40).isActive = true
        user_image.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    func setUsernameConstraints() {
        username.translatesAutoresizingMaskIntoConstraints = false
        username.topAnchor.constraint(equalTo: user_image.topAnchor, constant: 5).isActive = true
        username.leadingAnchor.constraint(equalTo: user_image.trailingAnchor, constant: 8).isActive = true
        username.heightAnchor.constraint(equalToConstant: 10).isActive = true
        username.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    func textViewContstraints() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 5).isActive = true
        textView.leadingAnchor.constraint(equalTo: user_image.trailingAnchor, constant: 8).isActive = true
        textView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        //        var frame = self.textView.frame
        //        frame.size.height = self.textView.contentSize.height
        //        self.textView.frame = frame
        //        textViewDidChange(textView: self.textView)
        
    }
    
    
}

class CommentCell:UITableViewCell {
    
    static var shared = CommentCell()
    var user_image = UIImageView()
    var username = UILabel()
    var imageLoader:DownloadImage?
    var stackView = UIStackView()
    var sub_comments:[Comments] = []
    var bottomConstraint:NSLayoutConstraint?
    var svBottomAnchor:NSLayoutConstraint?
    var parent_id:String?
    var offset:Int?
    weak var delegate:UpdateTableView?
    let comment_view = CommentView()
    
    override func prepareForReuse() {
        // invoke superclass implementation
        super.prepareForReuse()
            stackView.removeArrangedSubview(comment_view)
            comment_view.removeFromSuperview()
            viewMoreBtn.removeFromSuperview()
    }
        
    
    var components:URLComponents = {
        var component = URLComponents()
        component.scheme = "http"
        component.host = "localhost"
        component.port = 8000
        return component
    }()
    
    lazy var textView:UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.sizeToFit()
        tv.backgroundColor = UIColor.lightGray
        tv.textContainer.maximumNumberOfLines = 0
        tv.textContainer.lineBreakMode = .byCharWrapping
        tv.font = UIFont(name: "GillSans", size: 18)
        return tv
    }()
    
    lazy var repliesBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("View Replies ⌄", for: .normal)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(repliesBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var viewMoreBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("View More ⌄", for: .normal)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(viewMorePressed), for: .touchUpInside)
        return btn
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(user_image)
        setImageConstraints()
        setUsername()
        addSubview(username)
        setUsernameConstraints()
        addSubview(textView)
        addSubview(repliesBtn)
        textViewContstraints()
        repliesBtnConstraints()
        print("contentView \(contentView.frame.height)")
//        configureStackView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func repliesBtnPressed() {
        configureStackView()
        self.repliesBtn.removeFromSuperview()
        setStackViewContstraints()
        offset = 0
        setSuBComments()
        
    }
    
    @objc func viewMorePressed() {
        configureStackView()
        self.repliesBtn.removeFromSuperview()
        setStackViewContstraints()
        offset! += 2
        setSuBComments()
    }
    
    
    func configureStackView() {
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
//        stackView.sizeToFit()
    }
    
    func setSuBComments() {
        print("setSubComments")
        if let offset = offset {
        let getSubComments = GETSubComments(id: parent_id, path: "subComments", offset: "\(offset)")
               getSubComments.getAllById {
                   print($0)
                   self.sub_comments = $0
                   self.addCommentViewsToStackView(subComments: $0)
        }
        }
    }
    
    func addCommentViewsToStackView(subComments: [Comments]) {
       for i in subComments {
             comment_view.textView.text = i.text
             self.imageLoader = DownloadImage()
             imageLoader?.imageDidSet = { [weak self] image in
                self?.comment_view.user_image.image = image
             }
             if let picture = i.user_picture {
             imageLoader?.downloadImage(urlString: picture)
             }
             comment_view.username.text = i.username
             stackView.addArrangedSubview(comment_view)
          }
                addSubview(viewMoreBtn)
                viewMoreBtnConstraints()
                if let delegate = delegate {
                    delegate.updateTableView(bool: true)
                }
       }
    
    func setStackViewContstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -35).isActive = true
        stackView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 6).isActive = true
        stackView.leadingAnchor.constraint(equalTo: textView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: textView.trailingAnchor).isActive = true
        
    }
    
    
    
    func set(comment: Comments) {
        
        self.imageLoader = DownloadImage()
        imageLoader?.imageDidSet = { [weak self] image in
            self?.user_image.image = image
        }
        if (comment.user_picture?.contains("http"))! {
            if let comment_picture = comment.user_picture {
                imageLoader?.downloadImage(urlString: comment_picture)
            }
        } else {
            components.path = "/\(comment.user_picture)"
            if let comment_picture = components.url?.absoluteString {
                imageLoader?.downloadImage(urlString: comment_picture)
            }
        }
        
        username.text = comment.username
        if let comment_text = comment.text {
            textView.text = comment_text
        }
        
        
        
        
        
    }
    
    
    func setImageConstraints() {
        user_image.translatesAutoresizingMaskIntoConstraints = false
        user_image.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        user_image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        user_image.heightAnchor.constraint(equalToConstant: 40).isActive = true
        user_image.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    
    func setUsername() {
        username.textColor = UIColor.gray
        username.font = UIFont.systemFont(ofSize: 14)
    }
    
    func setUsernameConstraints() {
        username.translatesAutoresizingMaskIntoConstraints = false
        username.topAnchor.constraint(equalTo: user_image.topAnchor, constant: 5).isActive = true
        username.leadingAnchor.constraint(equalTo: user_image.trailingAnchor, constant: 8).isActive = true
        username.heightAnchor.constraint(equalToConstant: 10).isActive = true
        username.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    func textViewContstraints() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 5).isActive = true
        textView.leadingAnchor.constraint(equalTo: user_image.trailingAnchor, constant: 8).isActive = true
        textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60).isActive = true
//        textView.bottomAnchor.constraint(equalTo: repliesBtn.topAnchor).isActive = true
        //        var frame = self.textView.frame
        //        frame.size.height = self.textView.contentSize.height
        //        self.textView.frame = frame
        //        textViewDidChange(textView: self.textView)
        
    }
    
    func repliesBtnConstraints() {
        repliesBtn.translatesAutoresizingMaskIntoConstraints = false
        bottomConstraint =
        repliesBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6)
        bottomConstraint?.isActive = true
        repliesBtn.widthAnchor.constraint(equalTo: textView.widthAnchor).isActive = true
        repliesBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        repliesBtn.leadingAnchor.constraint(equalTo: textView.leadingAnchor).isActive = true
        repliesBtn.topAnchor.constraint(equalTo: textView.bottomAnchor).isActive = true
        
    }
    
    func viewMoreBtnConstraints() {
        viewMoreBtn.translatesAutoresizingMaskIntoConstraints = false
//        viewMoreBtn.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        viewMoreBtn.widthAnchor.constraint(equalTo: textView.widthAnchor).isActive = true
        viewMoreBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        viewMoreBtn.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 5).isActive = true
        viewMoreBtn.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 5).isActive = true
        
    }
    
    
    
    
}

