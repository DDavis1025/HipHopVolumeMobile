import UIKit
import Foundation

class CommentViewModel {
    var offset: Int = 0
    var buttonTag:[Int] = []
    static var parent_id:String?
    var mainComment: Comments?
    var mainCommentImage: UIImage?
    var subComments: [Comments] = []
    var commentLikes: [CommentLikes] = []
    var commentLikesDidInserts: (([CommentLikes]) -> ())?
    var subCommentDidInserts: (([Comments]) -> ())?
    var imageDownloader: DownloadImage?
    var symbolConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
    var likeBtnImage: UIImage? = UIImage(systemName: "heart")  { didSet { likeBtnImageDidSet?(likeBtnImage) } }
    var likeBtnImageDidSet: ((UIImage?)->())?
    var likeBtnTintColor: UIColor? = UIColor.darkGray { didSet { likeBtnTintColorDidSet?(likeBtnTintColor) } }
    var likeBtnTintColorDidSet: ((UIColor?)->())?
    var isLiked: Bool = false
    var isLikedLoaded: Bool = false

    
    func viewMore() {
        offset += 3
        loadSubComments()
    }
   
    func reply() {
        offset = 0
        loadSubComments()
    }
   
    func loadSubComments() {
        print("loadSubComments")
        let getSubComments = GETSubComments(id: CommentViewModel.parent_id, path: "subComments", offset: "\(offset)")
            getSubComments.getAllById {
                   self.subComments += $0
                   self.subCommentDidInserts?($0)
        }
    }
    
    func loadCommentLikes(id:String) {
        print("loadCommentLikes")
        let getCommentLikes = GETCommentLikes(id: id)
        getCommentLikes.getAllById {
            self.commentLikes = $0
            self.commentLikesDidInserts?($0)
        }
    }
    
    func getCommentLikesBuIserId(comment_id:String, user_id:String) {
           guard isLikedLoaded == false else { return }
           
          let getLikeByUser = GETCommentLikesByUserID(comment_id: comment_id, user_id: user_id)
           
           getLikeByUser.getAllById {
               if $0.count > 0 {
               self.likeBtnImage = UIImage(systemName: "heart.fill")
               self.likeBtnTintColor = .red
            
               self.isLiked = true
               self.isLikedLoaded = true
           }
       }
    }
    
    func likeComment(user_id: String, comment_id: String) {
         let commentLike = CommentLike(user_id: user_id, comment_id: comment_id)
               
               
               let postRequest = CommentLikePostRequest(endpoint: "addCommentLike")
               postRequest.save(commentLike) { (result) in
                   switch result {
                   case .success(let comment):
                       print("the following comment like has been sent: \(commentLike)")
                       self.loadCommentLikes(id: comment_id)
                   case .failure(let error):
                       print("An error occurred: \(error)")
                   }
               }
            self.likeBtnImage = UIImage(systemName: "heart.fill")
            self.likeBtnTintColor = .red
            self.isLiked = true
    }
    
    func unlikeComment(comment_id: String, user_id: String) {
       let deleteRequest = DLTCommentLike(comment_id: comment_id, user_id: user_id)
        
        deleteRequest.delete {(err) in
            if let err = err {
                print("Failed to delete", err)
                return
            }
            self.loadCommentLikes(id: comment_id)
            print("Successfully deleted comment like from server")
            }
            self.likeBtnImage = UIImage(systemName: "heart")
            self.likeBtnTintColor = .darkGray
            self.isLiked = false
    }
    
    
    func getSubCommentLikesByIserId(comment_id:String, user_id:String, completion: @escaping (Bool) -> ()) {
          print("it worked")
          let getLikeByUser = GETCommentLikesByUserID(comment_id: comment_id, user_id: user_id)
           
           getLikeByUser.getAllById {
               if $0.count > 0 {
               completion(true)
            } else {
              completion(false)
          }
       }
    }
    
    func likeSubComment(user_id: String, comment_id: String) {
        let commentLike = CommentLike(user_id: user_id, comment_id: comment_id)
        
        let postRequest = CommentLikePostRequest(endpoint: "addCommentLike")
        postRequest.save(commentLike) { (result) in
            switch result {
            case .success(let comment):
                print("the following sub comment like has been sent: \(commentLike)")
            //                       self.loadCommentLikes(id: comment_id)
            case .failure(let error):
                print("An error occurred: \(error)")
            }
        }
    }
    
    func unlikeSubComment(comment_id: String, user_id: String) {
       let deleteRequest = DLTCommentLike(comment_id: comment_id, user_id: user_id)
        
        deleteRequest.delete {(err) in
            if let err = err {
                print("Failed to delete", err)
                return
            }
//            self.loadCommentLikes(id: comment_id)
            print("Successfully deleted sub comment like from server")
            }
    }
    
    func loadSubCommentLikes(id:String, completion: @escaping ([CommentLikes]) -> ()) {
        print("loadSubCommentLikes")
        let getCommentLikes = GETCommentLikes(id: id)
        getCommentLikes.getAllById {
             completion($0)
        }
    }
    
    
    
    func updateParentId(newString:String) {
        CommentViewModel.self.parent_id = newString
    }
}

