//
//  CellWithPhoto.swift
//  eating_sustainably-login
//
//  Created by user191001 on 5/26/21.
//

import UIKit
import FirebaseFirestore

class CellWithPhoto: UITableViewCell {

    
    @IBOutlet weak var fotoUsuario: UIImageView!
    
    @IBOutlet weak var lbNombreUsuario: UILabel!
    
    @IBOutlet weak var lbtextoPost: UILabel!
    
    @IBOutlet weak var fotoPublicacion: UIImageView!
    
    
    func configure(post: FeedPost){
        self.lbNombreUsuario.text = post.author
        self.lbtextoPost.text = post.content
        
        if(post.getFoto() == "nil"){
            fotoPublicacion.image = UIImage(systemName: "avatarPerfil")
            fotoPublicacion.isHidden = true
        }
        else{
        Constantes.db.collection("posts").whereField("uid", isEqualTo: post.uid).whereField("foto", isEqualTo: post.getFoto()).getDocuments(){ (querySnapshot, err) in
            if let document = querySnapshot, !document.isEmpty {
                for doc in document.documents{
                    print(doc.get("foto") as! String)
                    Constantes.storage.child(doc.get("foto") as! String).getData(maxSize: 1 * 1024 * 1024){ data, error in if let error = error{
                       print("Error in loading photo")
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
}
