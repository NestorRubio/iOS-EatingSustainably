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
        
        Constantes.db.collection("posts").whereField("uid", isEqualTo: post.uid).whereField("foto", isEqualTo: post.getFoto()).getDocuments(){ (querySnapshot, err) in
            if let document = querySnapshot, !document.isEmpty {
                for doc in document.documents{
                    print(doc.get("foto") as! String)
                    Constantes.storage.child(doc.get("foto") as! String).getData(maxSize: 1 * 1024 * 1024){ data, error in
                        if let error = error{
                       print("Error in loading photo")
                        self.fotoPublicacion.image = UIImage(systemName: "avatarPerfil")
                    }
                    else{
                        if let foto = UIImage(data: data!){
                            self.fotoPublicacion.image = foto
                        }
                    }
                        
                    }
                }
            }
        }
    
    }
    
}
