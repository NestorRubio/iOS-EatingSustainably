//
//  Constantes.swift
//  eating_sustainably-login
//
//  Created by user190188 on 4/21/21.
//

import Foundation
import FirebaseFirestore

struct Constantes {
    struct Storyboard {
        static let homeViewController = "HomeVC"
    }
    
    
    static let NOMBRE_APP = "sustentax"
    
    static let db = Firestore.firestore()
    
    static let USER_ADMIN = 0
    static let USER_AGRICULTOR = 1
    static let USER_TENDERO = 2
    static let USER_RESTAURANTERO = 3
    static let USER_CONSUMIDOR = 4
    static let USER_INGENIERO = 5
    static let USER_TOTAL = 6
}

func getUserStringName(users: Int) -> String {
    switch users {
    case 0:
        return "Administrador"
    case 1:
        return "Agricultor"
    case 2:
        return "Tendero"
    case 3:
        return "Restaurantero"
    case 4:
        return "Consumidor"
    case 5:
        return "Ingeniero agrónomo"
    default:
        return "Error"
    }
}

func definirCategorias(usuario: Int)-> [String]{
    
    let productos = ["Frutas y vegetales", "Mariscos", "Carne", "Granos y semillas", "Otros"]
    let cocina = ["Méxicana", "Hamburguesa", "Pizza", "Americana", "Carne", "Otros"]
    
    switch usuario {
    case 0:
        return []
    case 1:
        return productos
    case 2:
        return productos
    case 3:
        return cocina
    case 4:
        return []
    case 5:
        return []
    default:
        return []
    }
    
    
}
