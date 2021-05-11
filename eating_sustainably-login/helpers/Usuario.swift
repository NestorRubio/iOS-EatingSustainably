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
    
    init(nombre : String? = nil, apellido : String? = nil, email : String? = nil, tipo : Int? = nil, uid : String? = nil){
        self.m_nombre = nombre
        self.m_apellido = apellido
        self.m_email = email
        self.m_tipo = tipo
        self.m_uid = uid
    }

}
