//
//  TiendaTableViewCell.swift
//  eating_sustainably-login
//
//  Created by user189360 on 5/21/21.
//

import UIKit

class TiendaTableViewCell: UITableViewCell {
    

    @IBOutlet weak var imgProducto: UIImageView!
    @IBOutlet weak var lbNombre: UILabel!
    @IBOutlet weak var lbCategoria: UILabel!
    @IBOutlet weak var lbDescripcion: UITextView!
    @IBOutlet weak var lbPrecio: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
