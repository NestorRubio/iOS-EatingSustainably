//
//  PerfilViewController.swift
//  eating_sustainably-login
//
//  Created by user189360 on 5/12/21.
//

import UIKit
import youtube_ios_player_helper

class PerfilViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, protocoloActualizar, UIWebViewDelegate {

    @IBOutlet weak var fotoPerfil: UIImageView!
    
    @IBOutlet weak var btnQR: UIButton!
    @IBOutlet weak var btnBloquear: UIButton!
    @IBOutlet weak var btnEliminar: UIButton!
    @IBOutlet weak var btnTienda: UIButton!
    @IBOutlet weak var btnEditar: UIButton!
    @IBOutlet weak var btnLocalizacion: UIButton!
    @IBOutlet weak var btnModificar: UIButton!
    @IBOutlet weak var btnVideo: UIButton!
    
    @IBOutlet weak var lbNombreUsuario: UILabel!
    @IBOutlet weak var lbCorreoUsuario: UILabel!
    @IBOutlet weak var historiaUsuario: UITextView!
    @IBOutlet weak var lbHistoria: UILabel!
    @IBOutlet weak var lbLocalizame: UILabel!
    @IBOutlet weak var lbTelefono: UILabel!
    @IBOutlet weak var lbTienda: UILabel!
    
    
    var usuarioVerPerfil : Usuario!
    var ver : Bool = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Mi Perfil"

        fotoPerfil.contentMode = .scaleAspectFit

        //personalizamos el botn de cerrar para que tenga imagen y texto
        let button = UIButton(type: .system)
        button.setTitle("Cerrar sesión  ", for: .normal)
        button.setTitleColor(.black,  for: .normal)
        button.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        //button.semanticContentAttribute = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        button.setImage(UIImage(systemName: "power"), for: .normal)
        button.tintColor = .red
        button.sizeToFit()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        

        button.addTarget(self, action: #selector(self.cerrarSesion), for: .touchUpInside)
        btnTienda.layer.cornerRadius = 8
        
        btnBloquear.isHidden = true

        // Checa que el usuario sea Agricultor, Restaurantero o Tendero para mostrar el boton de localizacion
        if (Constantes.usuario.m_tipo == Constantes.USER_AGRICULTOR || Constantes.usuario.m_tipo == Constantes.USER_TENDERO || Constantes.usuario.m_tipo == Constantes.USER_RESTAURANTERO) {
            //usuario vendedor
            
            btnLocalizacion.isHidden = false
            lbLocalizame.isHidden = false
            btnQR.isHidden = false
            lbTienda.isHidden = false
            btnTienda.isHidden = false
            // Muestra el telefono
            lbTelefono.isHidden = false
            lbTelefono.text! = Constantes.usuario.m_telefono!
            //muestra tienda
            btnTienda.setTitle(Constantes.usuario.m_negocio, for: .normal)
            lbHistoria.text = "Mi historia"
            if (Constantes.usuario.m_video != ""){
                btnVideo.isHidden = false
            }
            else {
                btnVideo.isHidden = true
            }

        }
        else {
            // Si el usuario no es agricultor, restaurantero o tendero no muestra el boton de localizacion
            btnLocalizacion.isHidden = true
            lbLocalizame.isHidden = true
            btnQR.isHidden = true
            lbTienda.isHidden = true
            btnTienda.isHidden = true
            lbHistoria.text = "Información personal"
            lbTelefono.isHidden = true
            btnVideo.isHidden = true
    
        }
        
        if (Constantes.usuario.m_foto != ""){
            fotoPerfil.image = Constantes.usuario.m_imagen
        }
        if (ver == true){
            title = "Perfil de "+usuarioVerPerfil.m_nombre!
            button.isEnabled = false
            navigationItem.rightBarButtonItems = []
            btnEditar.isHidden = true
            
            
            if (Constantes.usuario.m_tipo != Constantes.USER_ADMIN){
                btnBloquear.isHidden = true
                btnEliminar.isHidden = true
                btnEditar.isHidden = true
                btnQR.isHidden = true
                btnModificar.isHidden = true
                
            }
            else{
                btnBloquear.isHidden = false
                btnEliminar.isHidden = false
                btnEditar.isHidden = false
                btnQR.isHidden = false
                btnModificar.isHidden = false

            }
            
            if (usuarioVerPerfil.m_foto != ""){
                fotoPerfil.image = usuarioVerPerfil.m_imagen
            }
            else {
                fotoPerfil.image = UIImage(named: "avatarPerfil")
            }
            if (usuarioVerPerfil.m_tipo == Constantes.USER_AGRICULTOR || usuarioVerPerfil.m_tipo == Constantes.USER_TENDERO || usuarioVerPerfil.m_tipo == Constantes.USER_RESTAURANTERO) {
                //usuario vendedor
                btnLocalizacion.isHidden = false
                lbLocalizame.isHidden = false
                lbTienda.isHidden = false
                btnTienda.isHidden = false
                // Muestra el telefono
                lbTelefono.isHidden = false
                lbTelefono.text = usuarioVerPerfil.m_telefono!
                //muestra tienda
                btnTienda.setTitle(usuarioVerPerfil.m_negocio, for: .normal)
                lbHistoria.text = "Mi historia"
                if (usuarioVerPerfil.m_video != ""){
                    btnVideo.isHidden = false
                }
                else {
                    btnVideo.isHidden = true
                }

            }
            else {
                // Si el usuario no es agricultor, restaurantero o tendero no muestra el boton de localizacion
                btnLocalizacion.isHidden = true
                lbLocalizame.isHidden = true
                lbTienda.isHidden = true
                btnTienda.isHidden = true
                lbHistoria.text = "Información personal"
                lbTelefono.isHidden = true
                btnVideo.isHidden = true
        
            }
            // Muestra el nombre del usuario
            lbNombreUsuario.text! = usuarioVerPerfil.m_nombre! + " " + usuarioVerPerfil.m_apellido!
            // Muestra el correo del usuario
            lbCorreoUsuario.text = usuarioVerPerfil.m_email!
            // Muestra la informacion o historia del usuario
            historiaUsuario.text = usuarioVerPerfil.m_informacion!
        }
        else {
            // Muestra el nombre del usuario
            lbNombreUsuario.text! = Constantes.usuario.m_nombre! + " " + Constantes.usuario.m_apellido!
            // Muestra el correo del usuario
            lbCorreoUsuario.text = Constantes.usuario.m_email!
            // Muestra la informacion o historia del usuario
            historiaUsuario.text = Constantes.usuario.m_informacion!
        }
    }
    
    
    @objc func cerrarSesion(){
        do {
            try Constantes.auth.signOut()
        
            let portada = self.storyboard?.instantiateViewController(identifier: Constantes.Storyboard.portadaViewController) as? UINavigationController
            //Constantes.usuario = Usuario()

            //mostramos mensajes de confirmacion y vamos a portada cuando el usuario acepta
            self.present(mostrarMsj(error: Constantes.CERRAR_OK, hand: {(action) -> Void in self.view.window?.rootViewController = portada
                                        self.view.window?.makeKeyAndVisible()}), animated: true, completion: nil)
        }
        catch let signOutError as NSError {
            self.present(mostrarMsj(error: Constantes.ERROR_CERRAR), animated: true, completion: nil)
        }
    }
    
    @IBAction func agregarFoto(_ sender: UITapGestureRecognizer) {
        if (ver == false) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
    }
    //MARK: - Métodos de delgado UIImage Picker Controller
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let foto = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let data = foto.pngData()

        Constantes.storage.child("fotosPerfil/"+Constantes.usuario.m_uid!+".png").putData(data!, metadata: nil, completion: {_, error in
            if error == nil {
                Constantes.db.collection("users").document(Constantes.usuario.m_uid!).updateData(["foto": "fotosPerfil/"+Constantes.usuario.m_uid!+".png"]){ err in
                    if let err = err {
                        //error actualizar fireabse
                        self.present(mostrarMsj(error: Constantes.ERROR_FOTO_FB), animated: true, completion: nil)
                    }
                    else {
                        Constantes.usuario.m_foto = "fotosPerfil/"+Constantes.usuario.m_uid!+".png"
                        Constantes.usuario.m_imagen = foto
                        self.fotoPerfil.image = foto
                    }
                }
            }
            else {
                //error storage
                self.present(mostrarMsj(error: Constantes.ERROR_FOTO_ST), animated: true, completion: nil)
                return
            }
        })

        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)

    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "perfil_qr"{
            let viewBuscar = segue.destination as! CodigoQRViewController
        
        }
        else if segue.identifier == "perfil_bloquear"{
            let viewBloquear = segue.destination as! BloquearViewController
            viewBloquear.ver = self.ver
            viewBloquear.usuarioVerPerfil = self.usuarioVerPerfil
        }
        else if segue.identifier == "perfil_eliminar"{
            let viewEliminar = segue.destination as! EliminarViewController
            viewEliminar.ver = self.ver
            viewEliminar.usuarioVerPerfil = self.usuarioVerPerfil
        }
        else if segue.identifier == "perfil_modificar"{
            let viewModificar = segue.destination as! ModificarPasswordViewController
            viewModificar.ver = self.ver
            viewModificar.usuarioVerPerfil = self.usuarioVerPerfil
        }
        else if segue.identifier == "perfil_editar"{
            let viewEditar = segue.destination as! EditarPerfilUsuarioViewController
            viewEditar.ver = self.ver
            viewEditar.usuarioVerPerfil = self.usuarioVerPerfil
            viewEditar.delegado = self
        }
        else if segue.identifier == "perfil_mapa"{
            let viewMapa = segue.destination as! MapaUsuarioViewController
            viewMapa.ver = self.ver
            viewMapa.usuarioVerPerfil = self.usuarioVerPerfil
        }
        else if segue.identifier == "perfil_tienda"{
            let viewTienda = segue.destination as! TiendaViewController
            viewTienda.ver = self.ver
            viewTienda.usuarioVerPerfil = self.usuarioVerPerfil
        } else if segue.identifier == "perfil_video" {
            let viewVideo = segue.destination as! VerVideoViewController
            viewVideo.ver = self.ver
            viewVideo.usuarioVerPerfil = self.usuarioVerPerfil
        }
        
        
    }
    // MARK: - Métodos del protocolo actualizar
    func actualizarPerfil(nombre: String, apellido: String, info: String, tlf: String) {
        lbNombreUsuario.text = nombre + " " + apellido
        historiaUsuario.text = info
        lbTelefono.text = tlf
    }
}

