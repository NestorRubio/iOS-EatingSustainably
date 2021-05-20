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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Muestra los valores actuales
        tfPrimerNombre.text! = Constantes.usuario.m_nombre!
        tfApellido.text! = Constantes.usuario.m_apellido!
        tfLat.text! = String(Constantes.usuario.m_latitud!)
        tfLon.text! = String(Constantes.usuario.m_longitud!)
        
        // Do any additional setup after loading the view.
    }
    
    
    func guardarDatos() {
        
        let userObjUpdate = [
            "nombre": tfPrimerNombre.text!,
            "apellido": tfApellido.text!,
            "latitud": tfLat.text!,
            "longitud": tfLon.text!
        ] as [String:Any]
        
        Constantes.db.collection("users").document(Constantes.usuario.m_uid!).updateData(userObjUpdate){ err in
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
