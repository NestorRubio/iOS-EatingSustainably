//
//  Usuario.swift
//  eating_sustainably-login
//
//  Created by user189360 on 5/7/21.
//

import UIKit

class Usuario: NSObject {
    
    var m_nombre : String?
    var m_apellido : String?
    var m_email : String?
    var m_tipo : Int?
    var m_uid : String?
    var m_latitud : Double?
    var m_longitud : Double?
    var m_foto : String?
    var m_informacion : String?
    var m_imagen : UIImage?
    var m_estado : Int?
    
    //variables solo para tipo vendedor
    var m_video : String?
    var m_negocio : String?
    var m_proceso : String?
    var m_categorias : [Int]
    var m_telefono : String?
    
    init(nombre : String? = nil, apellido : String? = nil, email : String? = nil, tipo : Int? = nil, uid : String? = nil, latitud : Double? = nil, longitud : Double? = nil, foto : String? = nil, info : String? = nil, video : String? = nil, negocio : String? = nil, proceso : String? = nil, categorias : [Int] = [], tlf : String? = nil, estado : Int? = nil){
        self.m_nombre = nombre
        self.m_apellido = apellido
        self.m_email = email
        self.m_tipo = tipo
        self.m_uid = uid
        self.m_latitud = latitud
        self.m_longitud = longitud
        self.m_foto = foto
        self.m_informacion = info
        self.m_video = video
        self.m_negocio = negocio
        self.m_proceso = proceso
        self.m_categorias = categorias
        self.m_telefono = tlf
        self.m_estado = estado
    }

}
