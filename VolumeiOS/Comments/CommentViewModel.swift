//
//  CommentViewModel.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 6/23/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation

struct CommentViewModel {
    var offset:String?
    var id:String?
    var comment: Comments
    var subCommentDidChange: (Comments) -> ()
    var subComment: [Comment] {
        didSet {
            subCommentDidChange(subComments)
        }
    }
    func viewMore() {  }
    func replies() {  }
    func setSubcomments() {
        if let offset = offset {
        let getSubComments = GETSubComments(id: parent_id, path: "subComments", offset: "\(offset)")
               getSubComments.getAllById {
                   print($0)
                   self.subComments = $0
        }
    }
  }
}

