import UIKit
import Foundation

class CommentViewModel {
    var offset: Int = 0
    static var offsetForCell: Int = 0
    var buttonTag:[Int] = []
    static var parent_id:String?
    var mainComment: Comments?
    var mainCommentImage: UIImage?
    var commentLikes: [CommentLikes] = []
    var commentLikesDidInserts: (([CommentLikes]) -> ())?
    var subComments: [Comments] = []
    var subCommentDidInserts: (([Comments]) -> ())?
    var imageDownloader: DownloadImage?
    var symbolConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
    var likeBtnImage: UIImage? = UIImage(systemName: "heart")  { didSet { likeBtnImageDidSet?(likeBtnImage) } }
    var likeBtnImageDidSet: ((UIImage?)->())?
    var likeBtnTintColor: UIColor? = UIColor.darkGray { didSet { likeBtnTintColorDidSet?(likeBtnTintColor) } }
    var likeBtnTintColorDidSet: ((UIColor?)->())?
    var isLiked: Bool = false
    var isLikedLoaded: Bool = false
    var commentsExist:Bool?
    var commentsExistDidInserts: ((Bool) -> ())?
    var repliesExist:Bool?
    var repliesExistDidInserts: ((Bool) -> ())?
    var checkedReplies:Bool? = false
    var repliesBtn: UIButton?  { didSet { repliesBtnDidSet?(repliesBtn) } }
    var repliesBtnDidSet: ((UIButton?)->())?
    var viewMoreBtn: UIButton?  { didSet { viewMoreBtnDidSet?(viewMoreBtn) } }
    var viewMoreBtnDidSet: ((UIButton?)->())?

    


    
    func viewMore() {
        offset += 3
        loadSubComments()
    }
   
    func reply(id:String) {
        offset = 0
        loadSubComments()
        let offset2 = offset + 3
        commentsExist(comment_id: id, offset: offset2, completion: {
            
        })
    }
    
   
    func loadSubComments() {
        print("loadSubComments")
        let getSubComments = GETSubComments(id: CommentViewModel.parent_id, path: "subComments", offset: "\(offset)")
            getSubComments.getAllById {
                   self.subComments += $0
                   self.subCommentDidInserts?($0)
                   print("self.subComments did insert lsc \(self.subCommentDidInserts)")
        }
    }
    
    func commentsExist(comment_id: String, offset: String, completion: @escaping ([Comments]) -> ()) {
        let getSubComments = GETSubComments(id: comment_id, path: "subComments", offset: "\(offset)")
            getSubComments.getAllById {
            completion($0)
        }
    }
    
    func loadSubCommentsAfterReply(comment_id:String?, user_id:String?) {
        print("loadSubCommentsAfterReply")
        if let id = comment_id {
        let getSubComments = GETSubCommentAfterReply(id: id, user_id: user_id)

            getSubComments.getSubComment {
                   self.subComments += $0
                   self.subCommentDidInserts?($0)
                  
        }
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
    
    func likeSubComment(user_id: String, comment_id: String, completion: @escaping () -> ()) {
        let commentLike = CommentLike(user_id: user_id, comment_id: comment_id)
        
        let postRequest = CommentLikePostRequest(endpoint: "addCommentLike")
        postRequest.save(commentLike) { (result) in
            switch result {
            case .success(let comment):
                print("the following sub comment like has been sent: \(commentLike)")
                completion()
            //                       self.loadCommentLikes(id: comment_id)
            case .failure(let error):
                print("An error occurred: \(error)")
            }
        }
    }
    
    func unlikeSubComment(comment_id: String, user_id: String, completion: @escaping () -> ()) {
       let deleteRequest = DLTCommentLike(comment_id: comment_id, user_id: user_id)
        
        deleteRequest.delete {(err) in
            if let err = err {
                print("Failed to delete", err)
                return
            }
//            self.loadCommentLikes(id: comment_id)
            completion()
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
    
    func updateOffsetForCell(newInt:Int) {
        CommentViewModel.self.offsetForCell = newInt
    }
    
//    func updateCommentsExist(newBool:Bool) {
//        CommentViewModel.self.commentsExist = newBool
//    }
    
}

