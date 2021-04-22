//
//  TableViewCell.swift
//  ProtocoloCreacion
//
//  Created by user191001 on 4/7/21.
//

import UIKit;

class TableViewCell: UITableViewCell {

    @IBOutlet weak var nombreUsuario: UILabel!
    @IBOutlet weak var fotoUsuario: UIImageView!
    @IBOutlet weak var textoPublicacion: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        fotoUsuario.layer.cornerRadius = 32
        fotoUsuario.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
