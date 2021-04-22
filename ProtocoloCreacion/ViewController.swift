//
//  ViewController.swift
//  ProtocoloCreacion
//
//  Created by user191001 on 4/7/21.
//

import UIKit

class ViewController: UIViewController {
    
    var unaPublicacion : Publicacion!
    
    @IBOutlet weak var foto: UIImageView!
    
    @IBOutlet weak var nombre: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foto.image = unaPublicacion.foto
        nombre.text = unaPublicacion.nombreUsuario
        
    }


}

