//
//  FeedTableViewCell.swift
//  eating_sustainably-login
//
//  Created by user190188 on 5/17/21.
//

import UIKit
import FirebaseFirestore

class FeedTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    
    @IBOutlet weak var lbAuthor: UILabel!
    @IBOutlet weak var lbMessage: UILabel!
    @IBOutlet weak var lbLikes: UILabel!
    
    @IBOutlet weak var fotoPublicacion: UIImageView!
    
    func  configure(with post: FeedPost){
        lbAuthor.text = post.author
        lbMessage.text = post.content
        lbLikes.text = String(post.likes)
        imgProfilePic.image = post.fotoPerfil
        fotoPublicacion.image = post.fotoPub
    }
}
