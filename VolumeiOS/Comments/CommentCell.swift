import Foundation
import UIKit
import Combine

protocol HeightForTextView: class {
    func heightOfTextView(height: CGFloat)
}

class CommentCell:UITableViewCell {
    
    static var shared = CommentCell()
    var user_image = UIImageView()
    var username = UILabel()
    var imageLoader:DownloadImage?
    weak var myDelegate:HeightForTextView?
    
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

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(user_image)
        setImageConstraints()
        setUsername()
        addSubview(username)
        setUsernameConstraints()
        addSubview(textView)
        textViewContstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func textViewDidChange(textView: UITextView) {
        let fixedWidth: CGFloat = textView.frame.size.width
        let newSize: CGSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))

        myDelegate?.heightOfTextView(height: newSize.height)

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
        textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
//        var frame = self.textView.frame
//        frame.size.height = self.textView.contentSize.height
//        self.textView.frame = frame
//        textViewDidChange(textView: self.textView)
        
    }
    
    
    
}

