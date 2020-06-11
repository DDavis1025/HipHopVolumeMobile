//
//  ArtistTracksCell.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 6/10/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit

class ArtistTracksCell: ArtistAlbumsCell {
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      if let artistID = ArtistStruct.artistID {
        self.getArtist(id: artistID)
      }
    }
       
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func getArtist(id: String) {
        let getArtistById =  GETArtistById2(id: id, path:"artist/track")
        getArtistById.getAllById {
            self.artistData = $0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
        if let id = artistData[indexPath.row].id {
         if let title = artistData[indexPath.row].title {
          let trackVC = TrackPlayVC()
          trackVC.captureId(id: id)
          trackVC.trackName = title
          trackVC.justClicked = true
          parent?.navigationController?.present(trackVC, animated: true, completion: nil)
        }
     }
    }
    
}
