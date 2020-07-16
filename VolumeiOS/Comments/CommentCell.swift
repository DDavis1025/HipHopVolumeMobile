import Foundation
import UIKit
import Combine

protocol UpdateTableView: class {
    func updateTableView(bool: Bool)
}

protocol CommentViewDelegate: class {
    func subCommentLikePressed(sender: UIButton)
    func replyToSubComment(sender: UIButton)
    
}




class CommentView: UIView {
    
    weak var delegate: CommentViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(user_image)
        addSubview(username)
        addSubview(textView)
        addSubview(likeBtn)
        addSubview(numberOfLikes)
        addSubview(replyBtn)
        replyBtnConstraints()
        setImageConstraints()
        setUsernameConstraints()
        textViewContstraints()
        commentLikeBtnConstraints()
        commentLikesConstraints()
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var replyBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("Reply", for: .normal)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(replyToSubComment(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var likeBtn:UIButton = {
        let btn = UIButton()
        let symbol = UIImage(systemName: "heart")
        btn.setImage(symbol , for: .normal)
        btn.tintColor = UIColor.darkGray
        btn.isUserInteractionEnabled = true
        btn.addTarget(self, action: #selector(subCommentLikePressed(sender:)), for: .touchUpInside)
        return btn
    }()
    
    var numberOfLikes:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "0"
        return label
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
    
    @objc func subCommentLikePressed(sender:UIButton) {
        print("delegate \(delegate)")
        if let delegate = delegate {
            delegate.subCommentLikePressed(sender: sender)
        }
    }
    
    @objc func replyToSubComment(sender:UIButton) {
        print("delegate \(delegate)")
        if let delegate = delegate {
            delegate.replyToSubComment(sender: sender)
        }
    }
    
    func replyBtnConstraints() {
        replyBtn.translatesAutoresizingMaskIntoConstraints = false
        replyBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        replyBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        replyBtn.leadingAnchor.constraint(equalTo: textView.leadingAnchor).isActive = true
        replyBtn.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 1).isActive = true
        replyBtn.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    func commentLikesConstraints() {
        numberOfLikes.translatesAutoresizingMaskIntoConstraints = false
        numberOfLikes.widthAnchor.constraint(equalToConstant: 60).isActive = true
        numberOfLikes.heightAnchor.constraint(equalToConstant: 30).isActive = true
        numberOfLikes.centerXAnchor.constraint(equalTo: likeBtn.centerXAnchor).isActive = true
        numberOfLikes.topAnchor.constraint(equalTo: likeBtn.bottomAnchor, constant: -5).isActive = true
    }
    
    func commentLikeBtnConstraints() {
        likeBtn.translatesAutoresizingMaskIntoConstraints = false
        likeBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        likeBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        likeBtn.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        likeBtn.topAnchor.constraint(equalTo: textView.topAnchor, constant: -5).isActive = true
    }
    
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
        textView.trailingAnchor.constraint(equalTo: likeBtn.leadingAnchor, constant: -3).isActive = true
//        textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
//        textView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
//                var frame = self.textView.frame
//                frame.size.height = self.textView.contentSize.height
//                self.textView.frame = frame
//        //        textViewDidChange(textView: self.textView)
        
    }
    
    
}

extension UITableViewCell {
    var tableView: UITableView? {
        var p = self.superview
        while p != nil {
            if let t = p as? UITableView {
                return t
            }
            p = p?.superview
        }
        return nil
    }
    
    func viewContentLayoutIfNeed() {
        self.tableView?.beginUpdates()
        self.tableView?.endUpdates()
    }
    func viewContentSetNeedsDisplay() {
        UIView.performWithoutAnimation {
            self.tableView?.beginUpdates()
            self.tableView?.endUpdates()
        }
    }
}

protocol CommentCellDelegate {
    func didTapReplyBtn(parent_id: String, cell: CommentCell)
}

protocol CommentCellDelegate2: class {
    func didTapSubReplyBtn(username:String, parent_id:String, cell: CommentCell)
}

class CommentCell:UITableViewCell {
    
    static var shared = CommentCell()
    var imageLoader:DownloadImage?
    var user_image = UIImageView()
    var username = UILabel()
    var stackView = UIStackView()
    var sub_comments:[Comments] = []
    var bottomConstraint:NSLayoutConstraint?
    var svBottomAnchor:NSLayoutConstraint?
    var parent_id:String?
    var user_id:String?
    var offset:Int?
    weak var delegate:UpdateTableView?
    weak var delegate2:CommentCellDelegate2?
    var commentDelegate:CommentCellDelegate?
    let comment_view = CommentView()
    var liked:Bool = false
    var subCommentView:CommentView?
    var profile = SessionManager.shared.profile
    var index:IndexPath?
    var commentsExist:Bool?
    var viewModel: CommentViewModel? {
        didSet {
            if let item = viewModel {
                print("didSet cell")
                if let id = item.mainComment?.id, let user_id = profile?.sub {
                  parent_id = id
                  item.loadCommentLikes(id: id)
                  item.getCommentLikesBuIserId(comment_id: id, user_id: user_id)
                    if let commentsExist = item.notCheckedExists {
                    if commentsExist  {
                    item.viewRepliesExists(comment_id: id)
                    } else {
                        if let btnState = item.repliesBtnState {
                        self.repliesBtn.isHidden = btnState
                    }
                   }
                  }
                }
                
                
//                print("item.subCommentDidInserts \(item.subCommentDidInserts![0])")
                imageLoader = DownloadImage()
                imageLoader?.imageDidSet = { [weak self] image in
                    self?.user_image.image = image
                }
                if let picture = item.mainComment?.user_picture {
                imageLoader?.downloadImage(urlString: picture)
                }
                username.text = item.mainComment?.username
                textView.text = item.mainComment?.text
                stackView.arrangedSubviews.forEach {
                    stackView.removeArrangedSubview($0)
                    $0.removeFromSuperview()
                }
                
                item.repliesBtnStateDidSet = { [weak self] in
                    if let bool = $0 {
                    self?.repliesBtn.isHidden = bool
                  }
                }
                

                

                
                item.subComments.forEach { subComment in
                    print("didSet subComment")
                    subCommentView = CommentView()
                    self.subCommentView?.delegate = self
                    subCommentView?.textView.text = subComment.text
                    print("subComment.text \(subComment.text)")
                    imageLoader?.imageDidSet = { [weak self] image in
                        self?.subCommentView?.user_image.image = image
                    }
                    if let picture = subComment.user_picture {
                    imageLoader?.downloadImage(urlString: picture)
                    }
                    subCommentView?.username.text = subComment.username
                    
                    if let firstIndex = item.subComments.firstIndex(where: { $0.id == subComment.id }) {
                        subCommentView?.likeBtn.tag = firstIndex
                    }
                    
                    if subComment.isliked == true {
                    let image = UIImage(systemName: "heart.fill")
                    subCommentView?.likeBtn.setImage(image, for: .normal)
                    subCommentView?.likeBtn.tintColor = .red
                    }
                    if let numberOfLikes = subComment.numberOfLikes {
                    subCommentView?.numberOfLikes.text = "\(numberOfLikes)"
                    }

                    if let commentView = subCommentView {
                    stackView.addArrangedSubview(commentView)
                    }
                 
                }
                if item.subComments.isEmpty {
//                    repliesBtn.isHidden = false
//                    repliesBtn.isEnabled = true
                    viewMoreBtn.isHidden = true
                } else {
                    repliesBtn.isHidden = true
                    if let bool = item.viewMoreBtnState {
                    viewMoreBtn.isHidden = bool
                    }
                    self.viewMoreBtn.isEnabled = true
                }
                viewMoreBtn.isUserInteractionEnabled = true
                repliesBtn.isUserInteractionEnabled = true
                UIView.performWithoutAnimation {
                    viewMoreBtn.setTitle("View More", for: .normal)
                    repliesBtn.setTitle("View Replies", for: .normal)
                    likeBtn.setImage(item.likeBtnImage, for: .normal)
                    likeBtn.tintColor = item.likeBtnTintColor
                    
                }
                
        
                item.likeBtnImageDidSet = { [weak self] in self?.likeBtn.setImage($0, for: .normal) }
                item.likeBtnTintColorDidSet = { [weak self] in self?.likeBtn.tintColor = $0 }

               item.subCommentDidInserts = { [weak self] insertedSubComments in
               print("hello thur")
               guard let `self` = self else { return }
               insertedSubComments.forEach { subComment in
                let subCommentView = CommentView()
                subCommentView.delegate = self
                print("subComment.text didinsert \(subComment.text)")
                subCommentView.textView.text = subComment.text
                self.imageLoader?.imageDidSet = { [weak self] image in
                    subCommentView.user_image.image = image
                }
                if let picture = subComment.user_picture {
                    self.imageLoader?.downloadImage(urlString: picture)
                }
                
                subCommentView.username.text = subComment.username
                if let firstIndex = item.subComments.firstIndex(where: { $0.id == subComment.id }) {
                    subCommentView.likeBtn.tag = firstIndex
                    subCommentView.numberOfLikes.tag = firstIndex
                }

                    self.stackView.addArrangedSubview(subCommentView)
                   
                   if let comment_id = subComment.id, let user_id = self.profile?.sub {
                       item.getSubCommentLikesByIserId(comment_id: comment_id, user_id: user_id) { [weak subCommentView] bool in
                           if bool == true {
                            let image = UIImage(systemName: "heart.fill")
                            subCommentView?.likeBtn.setImage(image, for: .normal)
                            subCommentView?.likeBtn.tintColor = .red
                            if let index = subCommentView?.likeBtn.tag {
                            item.subComments[index].isliked = true
                         }
                        } else {
                            if let index = subCommentView?.likeBtn.tag {
                             item.subComments[index].isliked = false
                          }
                        }
                     }
                   }
                if let id = subComment.id {
                    item.loadSubCommentLikes(id: id) {[weak subCommentView] likes in
                        if let index = subCommentView?.likeBtn.tag {
                            item.subComments[index].numberOfLikes = likes.count
                        }
                        subCommentView?.numberOfLikes.text = "\(likes.count)"
                    }
                }
                   
            }
            
                    
                    UIView.animate(withDuration: 0.5, animations: {
                        self.stackView.isHidden = false
                        self.stackView.alpha = 1
                    })
                    self.viewMoreBtn.setTitle("View More", for: .normal)
                    self.viewMoreBtn.isUserInteractionEnabled = true
                    self.viewMoreBtn.isHidden = item.viewMoreBtnState!
                    self.viewMoreBtn.isEnabled = true
                    self.repliesBtn.setTitle("View Replies", for: .normal)
                    self.repliesBtn.isUserInteractionEnabled = true
                    self.repliesBtn.isHidden = true
                    self.viewContentLayoutIfNeed()
                }
                self.numberOfLikes.text = String(item.commentLikes.count)
                print("hello")
                
                item.commentLikesDidInserts = { [weak self] likes in
                    print("commentLikes comment cell \(likes)")
                    self?.numberOfLikes.text = String(likes.count)
                }
           }
        }
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
    
    lazy var likeBtn:UIButton = {
        let btn = UIButton()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
        let symbol = UIImage(systemName: "heart", withConfiguration: symbolConfig)
        btn.setImage(symbol , for: .normal)
        btn.tintColor = UIColor.darkGray
        btn.addTarget(self, action: #selector(commentLikePressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var numberOfLikes:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "0"
        return label
    }()
    
    lazy var mainReplyBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("Reply", for: .normal)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(mainCommentReplyPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var repliesBtn:UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.setTitle("View Replies", for: .normal)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(repliesBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var viewMoreBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("View More", for: .normal)
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
        addSubview(mainReplyBtn)
        addSubview(repliesBtn)
        addSubview(viewMoreBtn)
        addSubview(likeBtn)
        addSubview(numberOfLikes)
        configureStackView()
        textViewContstraints()
        commentLikeBtnConstraints()
        commentLikesConstraints()
        mainCommentReplyBtnConstraints()
        print("Text view bottomAnchor init \(textView.bottomAnchor.description)")
        setStackViewContstraints()
        repliesBtnConstraints()
        viewMoreBtnConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addedSubComment() {
          if let id = self.parent_id, let user_id = profile?.sub {
            self.viewModel?.loadSubCommentsAfterReply(comment_id: id, user_id: user_id)
      }
    }
    
    @objc func commentLikePressed() {
        guard let viewModel = viewModel else { return }
        if viewModel.isLiked {
            if let comment_id = parent_id, let user_id = profile?.sub {
            viewModel.unlikeComment(comment_id: comment_id, user_id: user_id)
            }
        } else {
            if let user_id = profile?.sub, let comment_id = parent_id {
            viewModel.likeComment(user_id: user_id, comment_id: comment_id)
            }
        }
    }
    
    
    @objc func mainCommentReplyPressed() {
        if let parent_id = parent_id {
            commentDelegate?.didTapReplyBtn(parent_id: parent_id, cell: self)
        }
    }
    
    @objc func repliesBtnPressed() {
        repliesBtn.setTitle("Loading...", for: .normal)
        repliesBtn.isUserInteractionEnabled = false
        if let id = self.parent_id {
        viewModel?.updateParentId(newString: id)
            viewModel?.reply(id: id)
            viewModel?.viewMoreBtnStateDidSet = { [weak self] in
                if let bool = $0 {
                self?.viewMoreBtn.isHidden = bool
              }
            }
        }
        
    }
    
    
    @objc func viewMorePressed() {
        viewMoreBtn.setTitle("Loading...", for: .normal)
        viewMoreBtn.isUserInteractionEnabled = false
        if let id = self.parent_id {
        viewModel?.updateParentId(newString: id)
        }
        viewModel?.viewMore()
    }
    
    
    func configureStackView() {
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
//        stackView.sizeToFit()
    }
    
    func commentLikesConstraints() {
        numberOfLikes.translatesAutoresizingMaskIntoConstraints = false
        numberOfLikes.widthAnchor.constraint(equalToConstant: 60).isActive = true
        numberOfLikes.heightAnchor.constraint(equalToConstant: 30).isActive = true
        numberOfLikes.centerXAnchor.constraint(equalTo: likeBtn.centerXAnchor).isActive = true
        numberOfLikes.topAnchor.constraint(equalTo: likeBtn.bottomAnchor, constant: -5).isActive = true
    }
    
    func commentLikeBtnConstraints() {
        likeBtn.translatesAutoresizingMaskIntoConstraints = false
        likeBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        likeBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        likeBtn.leadingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 3).isActive = true
        likeBtn.topAnchor.constraint(equalTo: textView.topAnchor, constant: -5).isActive = true
    }
    
    

    func mainCommentReplyBtnConstraints() {
        mainReplyBtn.translatesAutoresizingMaskIntoConstraints = false
        mainReplyBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        mainReplyBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        mainReplyBtn.leadingAnchor.constraint(equalTo: textView.leadingAnchor).isActive = true
        mainReplyBtn.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 1).isActive = true
        
    }
    

    
    func setStackViewContstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30).isActive = true
        stackView.topAnchor.constraint(equalTo: mainReplyBtn.bottomAnchor, constant: 42).isActive = true
        
        stackView.leadingAnchor.constraint(equalTo: textView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
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
//        textView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//                var frame = self.textView.frame
//                frame.size.height = self.textView.contentSize.height
//                self.textView.frame = frame
        //        textViewDidChange(textView: self.textView)
        
    }
    
    func repliesBtnConstraints() {
        repliesBtn.translatesAutoresizingMaskIntoConstraints = false
        bottomConstraint =
        repliesBtn.bottomAnchor.constraint(equalTo: stackView.topAnchor)
        bottomConstraint?.isActive = true
        repliesBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        repliesBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        repliesBtn.leadingAnchor.constraint(equalTo: textView.leadingAnchor).isActive = true
        repliesBtn.topAnchor.constraint(equalTo: mainReplyBtn.bottomAnchor).isActive = true
        
    }
    
    
    
    func viewMoreBtnConstraints() {
        viewMoreBtn.translatesAutoresizingMaskIntoConstraints = false
        viewMoreBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        viewMoreBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        viewMoreBtn.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 5).isActive = true
        viewMoreBtn.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 9).isActive = true
        
    }
    
  
    
}

extension CommentCell: CommentViewDelegate {
    

    func replyToSubComment(sender: UIButton) {
        let subCommentView = sender.superview as! CommentView
        if let username = subCommentView.username.text, let parent_id = parent_id {
            delegate2?.didTapSubReplyBtn(username: username, parent_id: parent_id, cell: self)
        }
    }
    
     @objc func subCommentLikePressed(sender:UIButton) {
           var comment_id:String?
           print("sender.tag now\(sender.tag)")
           comment_id = viewModel?.subComments[sender.tag].id
           guard let viewModel = viewModel else { return }
           if viewModel.subComments[sender.tag].isliked == true {
            print("order 1")
              if let user_id = profile?.sub, let comment_id = comment_id {
                viewModel.unlikeSubComment(comment_id: comment_id, user_id: user_id, completion: {
                    DispatchQueue.main.async {
                    if let id = viewModel.subComments[sender.tag].id {
                              viewModel.loadSubCommentLikes(id: "\(id)", completion: { likes in
                                  let subCommentView = sender.superview as! CommentView
                                  subCommentView.numberOfLikes.text = "\(likes.count)"
                                  viewModel.subComments[sender.tag].numberOfLikes = likes.count
                                  print("likes.count unlike \(likes.count)")
                                  print("order 2")
                              })
                              
                              }
                    }
                })
                    
               }
            let image = UIImage(systemName: "heart")
            sender.setImage(image, for: .normal)
            sender.tintColor = .darkGray
            
//           if let id = viewModel.subComments[sender.tag].id {
//           viewModel.loadSubCommentLikes(id: "\(id)", completion: { likes in
//               let subCommentView = sender.superview as! CommentView
//               subCommentView.numberOfLikes.text = ""
//               subCommentView.numberOfLikes.text = "\(likes.count)"
//               print("likes.count unlike \(likes.count)")
//               print("order 2")
//           })
//
//           }

            viewModel.subComments[sender.tag].isliked = false
         } else if viewModel.subComments[sender.tag].isliked == false {
            print("order 3")
               if let user_id = profile?.sub, let comment_id = comment_id {
                viewModel.likeSubComment(user_id: user_id, comment_id: comment_id, completion: {
                    DispatchQueue.main.async {
                    if let id = viewModel.subComments[sender.tag].id {
                    viewModel.loadSubCommentLikes(id: "\(id)", completion: { likes in
                        let subCommentView = sender.superview as! CommentView
                        subCommentView.numberOfLikes.text = "\(likes.count)"
                        viewModel.subComments[sender.tag].numberOfLikes = likes.count
                        print("likes.count like \(likes.count)")
                        print("order 4")
                        
                    })
                    }
                  }
                })
                let image = UIImage(systemName: "heart.fill")
                sender.setImage(image, for: .normal)
                sender.tintColor = .red
                
               }
               viewModel.subComments[sender.tag].isliked = true
          }
       }
    
}





