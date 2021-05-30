//
//  Constantes.swift
//  eating_sustainably-login
//
//  Created by user190188 on 4/21/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

struct Constantes {
    struct Storyboard {
        static let homeViewController = "HomeVC"
        static let portadaViewController = "PortadaVC"
        static let perfilViewController = "PerfilVC"
        static let splashViewController = "Splash"
        static let buscadorViewController = "BuscarVC"


    }
    
    static let  NOMBRE_APP = "sustentax"
    
    static let db = Firestore.firestore() 
    static let auth = Auth.auth()
    static let storage = Storage.storage().reference()
    static var usuario = Usuario()
    static var load = false

    
    
    //TIPO USUARIOS
    static let USER_ADMIN = 0
    static let USER_AGRICULTOR = 1
    static let USER_TENDERO = 2
    static let USER_RESTAURANTERO = 3
    static let USER_CONSUMIDOR = 4
    static let USER_INGENIERO = 5
    static let USER_TOTAL = 6
    
    //ESTADOS DE LA CUENTA
    static let CUENTA_ACTIVA = 0
    static let CUENTA_POR_VALIDAR = 1
    static let CUENTA_BLOQUEADA = 2
    static let CUENTA_ELIMINADA = 3
    
    //MENSAJE ERROR
    static let MAIL = 0
    static let PASSWORD = 1
    static let USERNAME = 2
    static let FIREBASE_PASSWORD = 3
    static let FIREBASE_MAIL = 4
    static let FIREBASE_BLOCK = 5
    static let PHONE = 6
    static let REGISTRO_OK = 7
    static let FIREBASE_MAIL_REPETIDO = 8
    static let TIPO_USER = 9
    static let NOMBRE_NEGOCIO = 10
    static let PROCESO = 11
    static let CATEGORIA = 12
    static let PERMISOS_LOC = 13
    static let VALIDAR = 14
    static let RECUPERAR = 15
    static let VALIDAR_VACIO = 16
    static let VALIDAR_OK = 17
    static let QR_GENERAR = 18
    static let ERROR_FOTO_FB = 19
    static let ERROR_FOTO_ST = 20
    static let CERRAR_OK = 21
    static let ERROR_CERRAR = 22
    static let PASSWORD_DIFERENTE = 23
    static let BUSQUEDA = 24
    static let BUSCAR_VACIO = 25
    static let UBICACION_ACTU = 26
    static let EDITAR_OK = 27
    static let NOMBRE_PRODUCTO = 28
    static let DESCRIPCION = 29
    static let PRECIO_VACIO = 30
    static let PRECIO_NUMERO = 31
    static let PRODUCTO_OK = 32
    static let TIENDA_VACIA = 33
    static let PUBLICACION_OK = 34
    static let ERROR_ELIMINAR = 35
    static let ELIMINAR_OK = 36
    static let ERROR_BLOQUEAR = 37
    static let BLOQUEAR_OK = 38
    static let BLOQUEADA = 39
    static let ELIMINADA = 40
    static let DESBLOQUEAR_OK = 41
    static let ERROR_DESBLOQUEAR = 42
    static let ERROR_EMAIL = 43
    static let PASSWORD_COINCIDE = 44
    static let ERROR_ACTUALIZAR_PASSWORD = 45
    static let ACTUALIZAR_PASSWORD_OK = 46
    static let ERROR_FEED = 47

    static let DEFAULT = 99
    
    //PATRONES DATOS
    static let EMAIL_PATTERN = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let PASSWORD_PATTERN = "^(?=.*[A-Z])(?=.*[!@#$&*-])(?=.*[0-9])(?=.*[a-z]).{8,}$"
    static let PHONE_PATTERN = "^(\\+52|0052|52)?[0-9]{10}$"

}

func getUserStringName(users: Int) -> String {
    switch users {
    case Constantes.USER_ADMIN:
        return "Administrador"
    case Constantes.USER_AGRICULTOR:
        return "Agricultor"
    case Constantes.USER_TENDERO:
        return "Tendero"
    case Constantes.USER_RESTAURANTERO:
        return "Restaurantero"
    case Constantes.USER_CONSUMIDOR:
        return "Consumidor"
    case Constantes.USER_INGENIERO:
        return "Ingeniero agrónomo"
    default:
        return "Error"
    }
}

func definirCategorias(usuario: Int)-> [String]{
    
    let productos = ["Frutas y vegetales", "Mariscos", "Carne", "Granos y semillas", "Otros"]
    let cocina = ["Méxicana", "Hamburguesa", "Pizza", "Americana", "Carne", "Otros"]
    
    switch usuario {
    case Constantes.USER_ADMIN:
        return []
    case Constantes.USER_AGRICULTOR:
        return productos
    case Constantes.USER_TENDERO:
        return productos
    case Constantes.USER_RESTAURANTERO:
        return cocina
    case Constantes.USER_CONSUMIDOR:
        return []
    case Constantes.USER_INGENIERO:
        return []
    default:
        return []
    }
}

func mostrarMsj(error: Int, hand : ((UIAlertAction)->Void)? = nil) -> UIAlertController {
    var titulo : String = "Error"
    var mensaje : String = ""
    
    switch error {
    case Constantes.MAIL:
        mensaje = "Introduce una dirección e-mail válida"
        break
    case Constantes.PASSWORD:
        mensaje = "Introduce una contraseña de al menos 8 dígitos con 1 mayúscula, 1 minúscula, 1 número y 1 carácter especial"
        break
    case Constantes.USERNAME:
        mensaje = "Introduce nombre de usuario válido"
        break
    case Constantes.FIREBASE_PASSWORD:
        mensaje = "La contraseña es incorrecta"
        break
    case Constantes.FIREBASE_MAIL:
        mensaje = "El e-mail introducido no está registrado"
        break
    case Constantes.FIREBASE_BLOCK:
        mensaje = "La cuenta está bloqueada por el administrador"
        break
    case Constantes.PHONE:
        mensaje = "El número de teléfono es incorrecto"
        break
    case Constantes.REGISTRO_OK:
        titulo = "Proceso completado"
        mensaje = "Usuario registrado con éxito"
        break
    case Constantes.FIREBASE_MAIL_REPETIDO:
        mensaje = "Ya hay un usuario registrado con el e-mail introducido"
        break
    case Constantes.TIPO_USER:
        mensaje = "Selecciona un tipo de usuario para la cuenta"
        break
    case Constantes.NOMBRE_NEGOCIO:
        mensaje = "Introduce el nombre del negocio"
        break
    case Constantes.PROCESO:
        mensaje = "Introduce el proceso sustentable del negocio"
        break
    case Constantes.CATEGORIA:
        mensaje = "Selecciona al menos una categoría"
        break
    case Constantes.PERMISOS_LOC:
        mensaje = "Habilita los permisos de ubicación para finalizar el registro"
        break
    case Constantes.VALIDAR:
        mensaje = "Usuario pendiente de ser validado"
        break
    case Constantes.RECUPERAR:
        titulo = "Proceso completado"
        mensaje = "Se ha enviado un e-mail para reestablecer la contraseña"
        break
    case Constantes.VALIDAR_VACIO:
        titulo = "Aviso"
        mensaje = "No hay usuarios pendientes de validar"
        break
    case Constantes.VALIDAR_OK:
        titulo = "Proceso completado"
        mensaje = "El usuario ha sido validado con éxito"
        break
    case Constantes.QR_GENERAR:
        mensaje = "No se ha podido generar el código QR"
        break
    case Constantes.ERROR_FOTO_FB:
        mensaje = "No se ha podido guardar la foto"
        break
    case Constantes.ERROR_FOTO_ST:
        mensaje = "No se ha podido subir la foto, vuelve a intentarlo"
        break
    case Constantes.CERRAR_OK:
        titulo = "Sesión cerrada"
        mensaje = "Se ha cerrado sesión de forma segura"
        break
    case Constantes.ERROR_CERRAR:
        mensaje = "No se ha podido cerrar sesión correctamente"
        break
    case Constantes.PASSWORD_DIFERENTE:
        mensaje = "Las contraseñas no coinciden"
        break
    case Constantes.BUSQUEDA:
        mensaje = "Introduce al menos un criterio de búsqueda"
        break
    case Constantes.BUSCAR_VACIO:
        mensaje = "No se han encontrado resultados de la búsqueda"
        break
    case Constantes.UBICACION_ACTU:
        titulo = "Confirma los cambios"
        mensaje = "Guarda los cambios para actualizar la ubicación de tu negocio"
        break
    case Constantes.EDITAR_OK:
        titulo = "Proceso completado"
        mensaje = "Se ha actualizado el perfil"
        break
    case Constantes.NOMBRE_PRODUCTO:
        mensaje = "Introduce el nombre del producto"
        break
    case Constantes.DESCRIPCION:
        mensaje = "Escribe la descripción del producto"
        break
    case Constantes.PRECIO_VACIO:
        mensaje = "Introduce el precio del producto"
        break
    case Constantes.PRECIO_NUMERO:
        mensaje = "Sólo se aceptan valores númericos y decimales"
        break
    case Constantes.PRODUCTO_OK:
        titulo = "Proceso completado"
        mensaje = "Se ha añadido el producto a tu tienda"
        break
    case Constantes.TIENDA_VACIA:
        titulo = "Aviso"
        mensaje = "La tienda está vacía, agrega productos"
        break
    case Constantes.PUBLICACION_OK:
        titulo = "Proceso completado"
        mensaje = "Se ha publicado tu cometnario"
        break
    case Constantes.ERROR_ELIMINAR:
        mensaje = "No se ha podido eliminar el usuario"
        break
    case Constantes.ELIMINAR_OK:
        titulo = "Usuario eliminado"
        mensaje = "Contacta con soporte para recuperar la cuenta"
        break
    case Constantes.ERROR_BLOQUEAR:
        mensaje = "No se ha podido bloquear al usuario"
        break
    case Constantes.BLOQUEAR_OK:
        titulo = "Aviso"
        mensaje = "Se ha bloqueado al usuario bloqueado con éxito"
        break
    case Constantes.BLOQUEADA:
        mensaje = "Usuario bloqueado, contacta con soporte para conocer el motivo"
        break
    case Constantes.ELIMINADA:
        mensaje = "Usuario elimiando, contacta con soporte para recuperar tu cuenta"
        break
    case Constantes.DESBLOQUEAR_OK:
        titulo = "Aviso"
        mensaje = "Se ha desbloqueado al usuario con éxito"
        break
    case Constantes.ERROR_DESBLOQUEAR:
        mensaje = "No se ha podido desbloquear al usuario"
        break
    case Constantes.ERROR_EMAIL:
        mensaje = "Escribe correctamente el e-mail de tu cuenta"
        break
    case Constantes.PASSWORD_COINCIDE:
        titulo = "Error al repetir"
        mensaje = "Las contraseñas no coinciden"
        break
    case Constantes.ERROR_ACTUALIZAR_PASSWORD:
        mensaje = "No se pudo actualizar la contraseña. Intentelo de nuevo"
        break
    case Constantes.ACTUALIZAR_PASSWORD_OK:
        titulo = "Operación completada"
        mensaje = "Contraseña actualizada correctamente"
        break
    case Constantes.ERROR_FEED:
        mensaje = "El mensaje de la publicación no puede estar vacío"
        break
        
        
    case Constantes.DEFAULT:
        mensaje = "Error al procesar la operación, vuelve a intentarlo"
        break
    default:
        mensaje = "Error"
        break
    }
    
    let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
    let accion = UIAlertAction(title: "OK", style: .cancel, handler:hand)
    alerta.addAction(accion)
    
    return alerta
}

func isValidPattern(_ texto: String, tipo: Int) -> Bool {
    var pattern : String!
    switch tipo {
    case Constantes.MAIL:
        pattern = Constantes.EMAIL_PATTERN
        break;
    case Constantes.PASSWORD:
        pattern = Constantes.PASSWORD_PATTERN
        break;
    case Constantes.PHONE:
        pattern = Constantes.PHONE_PATTERN
        break;
    default:
        return false;
    }
    let textoPred = NSPredicate(format:"SELF MATCHES %@", pattern)
    return textoPred.evaluate(with: texto)
}
