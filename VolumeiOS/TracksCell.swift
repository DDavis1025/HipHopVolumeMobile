import Foundation
import UIKit

class TracksCell: AlbumCell {
         override init(frame: CGRect) {
           super.init(frame: frame)
   //        addSpinner()
           spinner.startAnimating()
            GetAllOfMediaType(path:"tracks").getAllPosts {
                       self.posts = $0
                   }

           refresher = UIRefreshControl()
           refresher?.attributedTitle = NSAttributedString(string: "Pull to refresh")
           refresher?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
           
           addTableView()
                  
           myTableView.addSubview(refresher!)
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc override func refresh() {
        GetAllOfMediaType(path:"tracks").getAllPosts {
            self.posts = $0
        }
        
    }
    
    override func addTableView() {
    super.addTableView()
           
        self.myTableView.register(FeedCell.self, forCellReuseIdentifier: "MyCell")
           
            
}
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            if let id = posts[indexPath.row].id {
             if let path = posts[indexPath.row].title {
                if let author_id = posts[indexPath.row].author {
              let trackVC = TrackPlayVC()
              trackVC.captureId(id: id)
              trackVC.trackName = path
              trackVC.author_id = author_id
              trackVC.justClicked = true
              let modalVC = UINavigationController(rootViewController: trackVC)

              parent?.navigationController?.present(modalVC, animated: true, completion: nil)
            }
         }
       }
    }
    

    
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") as! FeedCell
            
        let post = posts[indexPath.row]
        
        cell.set(post: post)
       
        cell.setUser(user: userDictionary[posts[indexPath.row].author!])


        return cell
    }
}


