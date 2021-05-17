//
//  EditarPerfilUsuarioViewController.swift
//  eating_sustainably-login
//
//  Created by Enrique Elizondo on 5/16/21.
//

import UIKit
import Firebase
import FirebaseAuth

class EditarPerfilUsuarioViewController: UIViewController {
    
    @IBOutlet weak var tfPrimerNombre: UITextField!
    @IBOutlet weak var tfApellido: UITextField!
    @IBOutlet weak var tfLat: UITextField!
    @IBOutlet weak var tfLon: UITextField!
    
    @IBOutlet weak var lbTelefono: UILabel!
    @IBOutlet weak var tfTelefono: UITextField!
    @IBOutlet weak var lbNegocio: UILabel!
    @IBOutlet weak var tfNegocio: UITextField!
    
    @IBOutlet weak var lbHistoria: UILabel!
    @IBOutlet weak var tvHistoria: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Muestra los valores actuales
        tfPrimerNombre.text! = Constantes.usuario.m_nombre!
        tfApellido.text! = Constantes.usuario.m_apellido!
        tfLat.text! = String(Constantes.usuario.m_latitud!)
        tfLon.text! = String(Constantes.usuario.m_longitud!)
        
        // Do any additional setup after loading the view.
        
        // Si el tipo de usuario no es Restaurantero no mostrara los campos Telefono, Negocio e Historia
        if Constantes.usuario.m_tipo != Constantes.USER_RESTAURANTERO {
            tfNegocio.isHidden = true
            lbNegocio.isHidden = true
            lbTelefono.isHidden = true
            tfTelefono.isHidden = true
            lbHistoria.isHidden = true
            tvHistoria.isHidden = true
        } else {
            tfTelefono.text! = Constantes.usuario.m_telefono!
            tfNegocio.text! = Constantes.usuario.m_negocio!
            tvHistoria.text! = Constantes.usuario.m_informacion!
        }
    }
    
    // Guardar datos
    func guardarDatos() {
        
        // guarda datos diferentes si es Restaurantero a si es otro tipo de usuario
        // Si el usuario no es restaurantero
        if Constantes.usuario.m_tipo != Constantes.USER_RESTAURANTERO {
            
            // Datos a guardar editados
            let userObjUpdate = [
                "nombre": tfPrimerNombre.text!,
                "apellido": tfApellido.text!,
                "latitud": tfLat.text!,
                "longitud": tfLon.text!
            ] as [String:Any]
            
            Constantes.db.collection("users").document(Constantes.usuario.m_uid!).updateData(userObjUpdate) { err in
                if err != nil {
                    //error actualizar fireabse
                    self.present(mostrarMsj(error: Constantes.ERROR_FOTO_FB), animated: true, completion: nil)
                }
                else {
                    Constantes.usuario.m_nombre = self.tfPrimerNombre.text!
                    Constantes.usuario.m_apellido = self.tfApellido.text!
                    Constantes.usuario.m_latitud = Double(self.tfLat.text!)
                    Constantes.usuario.m_longitud = Double(self.tfLon.text!)
                }
            }
            
        // Si el usuario es restaurantero
        } else {
            // Datos a guardar editados
            let userObjUpdate = [
                "nombre": tfPrimerNombre.text!,
                "apellido": tfApellido.text!,
                "latitud": tfLat.text!,
                "longitud": tfLon.text!,
                "informacion": tvHistoria.text!,
                "negocio": tfNegocio.text!,
                "telefono": tfTelefono.text!
            ] as [String:Any]
            
            Constantes.db.collection("users").document(Constantes.usuario.m_uid!).updateData(userObjUpdate) { err in
                if err != nil {
                    //error actualizar fireabse
                    self.present(mostrarMsj(error: Constantes.ERROR_FOTO_FB), animated: true, completion: nil)
                }
                else {
                    Constantes.usuario.m_nombre = self.tfPrimerNombre.text!
                    Constantes.usuario.m_apellido = self.tfApellido.text!
                    Constantes.usuario.m_latitud = Double(self.tfLat.text!)
                    Constantes.usuario.m_longitud = Double(self.tfLon.text!)
                    Constantes.usuario.m_informacion = self.tvHistoria.text!
                    Constantes.usuario.m_negocio = self.tfNegocio.text!
                    Constantes.usuario.m_telefono = self.tfTelefono.text!
                }
            }
        }
        
        
    }
    
    
    
    
    
    @IBAction func btnGuardarCambios(_ sender: UIButton) {
        
        guardarDatos()
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
