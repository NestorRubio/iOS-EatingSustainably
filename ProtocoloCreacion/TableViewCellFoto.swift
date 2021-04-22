//
//  TableViewCellFoto.swift
//  ProtocoloCreacion
//
//  Created by user191001 on 4/22/21.
//

import UIKit

class TableViewCellFoto: UITableViewCell {
    
    @IBOutlet weak var nombreUsuario: UILabel!
    @IBOutlet weak var fotoUsuario: UIImageView!
    @IBOutlet weak var textoPublicacion: UITextView!
    @IBOutlet weak var fotoPublicacion: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        fotoUsuario.layer.cornerRadius = 32
        fotoUsuario.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
