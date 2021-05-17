//
//  PerfilViewController.swift
//  eating_sustainably-login
//
//  Created by user189360 on 5/12/21.
//

import UIKit

class PerfilViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var fotoPerfil: UIImageView!
    @IBOutlet weak var btnQR: UIButton!

    @IBOutlet weak var btnBloquear: UIButton!
    @IBOutlet weak var btnEliminar: UIButton!
    
    @IBOutlet weak var lbNombreUsuario: UILabel!
    @IBOutlet weak var lbCorreoUsuario: UILabel!
    @IBOutlet weak var historiaUsuario: UITextView!
    @IBOutlet weak var lbVideo: UILabel!
    @IBOutlet weak var btnVideo: UIButton!
    @IBOutlet weak var btnLocalizacion: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Perfil"
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

        if (Constantes.usuario.m_tipo == Constantes.USER_AGRICULTOR || Constantes.usuario.m_tipo == Constantes.USER_TENDERO || Constantes.usuario.m_tipo == Constantes.USER_RESTAURANTERO) {
            //usuario vendedor
            btnBloquear.isHidden = true

        }
        else {
            btnQR.isHidden = true
        }
        
        if (Constantes.usuario.m_foto != ""){
            fotoPerfil.image = Constantes.usuario.m_imagen
        }
        
        // Checa que el usuario sea Agricultor o Restaurantero para mostrar el boton de localizacion
        if(Constantes.usuario.m_tipo == Constantes.USER_AGRICULTOR || Constantes.usuario.m_tipo == Constantes.USER_RESTAURANTERO) {
            btnLocalizacion.isHidden = false
            lbVideo.isHidden = false
            btnVideo.isHidden = false
            
        } else {
            // Si el usuario no es agricultor o restaurantero no muestra el boton de localizacion
            btnLocalizacion.isHidden = true
            btnVideo.isHidden = true
            lbVideo.isHidden = true
        }
        
        // Muestra el nombre del usuario
        lbNombreUsuario.text! = Constantes.usuario.m_nombre! + " " + Constantes.usuario.m_apellido!
        // Muestra el correo del usuario
        lbCorreoUsuario.text = Constantes.usuario.m_email!
        // Muestra la informacion o historia del usuario
        historiaUsuario.text = Constantes.usuario.m_informacion!

    }
    
    
    @objc func cerrarSesion(){
        do {
            try Constantes.auth.signOut()
        
            let portada = self.storyboard?.instantiateViewController(identifier: Constantes.Storyboard.portadaViewController) as? UINavigationController
            
            //mostramos mensajes de confirmacion y vamos a portada cuando el usuario acepta
            self.present(mostrarMsj(error: Constantes.CERRAR_OK, hand: {(action) -> Void in self.view.window?.rootViewController = portada
                                        self.view.window?.makeKeyAndVisible()}), animated: true, completion: nil)
        }
        catch let signOutError as NSError {
            self.present(mostrarMsj(error: Constantes.ERROR_CERRAR), animated: true, completion: nil)
        }
    }
    
    @IBAction func agregarFoto(_ sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    //MARK: - Métodos de delgado UIImage Picker Controller
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let foto = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let data = foto.pngData()

        Constantes.storage.child("fotosPerfil/"+Constantes.usuario.m_uid!+".png").putData(data!, metadata: nil, completion: {_, error in
            if error == nil {
                Constantes.storage.child("fotosPerfil/"+Constantes.usuario.m_uid!+".png").downloadURL(completion: { url, error in
                    if error == nil, let url = url {
                        Constantes.db.collection("users").document(Constantes.usuario.m_uid!).updateData(["foto": url.absoluteString]){ err in
                            if let err = err {
                                //error actualizar fireabse
                                self.present(mostrarMsj(error: Constantes.ERROR_FOTO_FB), animated: true, completion: nil)
                            }
                            else {
                                Constantes.usuario.m_foto = url.absoluteString
                                Constantes.usuario.m_imagen = foto
                                self.fotoPerfil.image = foto
                            }
                        }
                    }
                    else {
                        //error storage
                        self.present(mostrarMsj(error: Constantes.ERROR_FOTO_ST), animated: true, completion: nil)
                    }
                })
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
            let viewSoporte = segue.destination as! BloquearViewController
        }
        else if segue.identifier == "perfil_eliminar"{
            let viewSoporte = segue.destination as! EliminarViewController
        
        } else if segue.identifier == "perfil_modificar"{
            let viewSoporte = segue.destination as! ModificarPasswordViewController
        }
    }
}

