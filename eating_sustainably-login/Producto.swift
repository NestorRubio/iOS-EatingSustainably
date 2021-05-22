//
//  Producto.swift
//  eating_sustainably-login
//
//  Created by user189360 on 5/21/21.
//

import UIKit

class Producto: NSObject {
    
    var m_nombre : String
    var m_categoria : String
    var m_descripcion : String
    var m_precio : Double
    var m_imagen : UIImage?
    var m_uidProducto : String
    var m_uidVendedor : String
    
    init(nombre : String, categoria : String, descripcion : String, precio : Double, imagen : UIImage? = nil, uidProducto : String, uidVendedor : String){
        self.m_nombre = nombre
        self.m_categoria = categoria
        self.m_descripcion = descripcion
        self.m_precio = precio
        self.m_imagen = imagen
        self.m_uidProducto = uidProducto
        self.m_uidVendedor = uidVendedor
    }

    

}
