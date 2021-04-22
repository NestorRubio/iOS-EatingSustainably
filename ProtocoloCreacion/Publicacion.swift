//
//  Jugador.swift
//  ProtocoloCreacion
//
//  Created by user191001 on 4/7/21.
//

import UIKit

class Publicacion: NSObject {
    
    var nombreUsuario:String!
    var fotoUsuario:UIImage!
    var texto: String!
    var fotoPublicacion:UIImage?
    
    init(nombreUsuario:String, fotoUsuario:UIImage!, texto: String,fotoPublicacion: UIImage!) {
        
        self.texto = texto
        self.nombreUsuario = nombreUsuario
        self.fotoUsuario = fotoUsuario
        self.fotoPublicacion = fotoPublicacion
        
    }
    
    init(nombreUsuario: String, fotoUsuario:UIImage!,texto: String){
        
        self.nombreUsuario = nombreUsuario
        self.texto = texto
        self.fotoUsuario = fotoUsuario
        
    }

}
