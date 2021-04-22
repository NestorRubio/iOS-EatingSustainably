//
//  Registro2ViewController.swift
//  eating_sustainably-login
//
//  Created by user189360 on 4/21/21.
//

import UIKit
import FirebaseAuth

class Registro2ViewController: UIViewController, UITextViewDelegate {
    
    

    var nombre : String?
    var apellido : String?
    var email  : String?
    var contraseña : String?
    var tipoUsuario : Int?
    var placeholder : String = "Escribe tu historia personal"
    
    
    @IBOutlet weak var tfNombreNegocio: UITextField!

    @IBOutlet weak var tfInformacion: UITextView!
    
    @IBOutlet weak var btnVideo: UIButton!
    
    @IBOutlet weak var btnContinuar: UIButton!
    
    @IBOutlet weak var lbError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Información Adicional"
        
        //ocultamos los cambos segun el tipo de usuario
        if (tipoUsuario! == Constantes.USER_CONSUMIDOR || tipoUsuario! == Constantes.USER_INGENIERO){
            btnVideo.isHidden = true
            tfNombreNegocio.isHidden = true
            placeholder = "Información personal"
            btnContinuar.setTitle("Registrarse", for: .normal)
        }
        tfInformacion.delegate = self
        self.tfInformacion.layer.borderColor = UIColor.lightGray.cgColor
        tfInformacion.layer.borderWidth = 1.0
        btnContinuar.layer.cornerRadius = 8

        tfInformacion.text = placeholder
        tfInformacion.textColor = UIColor.lightGray
        
        lbError.text = ""
        
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if tfInformacion.textColor == UIColor.lightGray {
            tfInformacion.text = nil
            tfInformacion.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if tfInformacion.text.isEmpty {
            tfInformacion.text = placeholder
            tfInformacion.textColor = UIColor.lightGray
        }
    }
    
    // MARK: - Navigation


    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        var ejecutarSegue = true
        if (tipoUsuario! == Constantes.USER_CONSUMIDOR || tipoUsuario! == Constantes.USER_INGENIERO){
            ejecutarSegue = false

            Auth.auth().createUser(withEmail: self.email!, password: self.contraseña!){
                
                    (result, error) in
                    if let result = result, error == nil{

                        Constantes.db.collection("users").document(result.user.uid).setData(["nombre": self.nombre, "apellido":self.apellido, "email":self.email, "tipoUsuario":self.tipoUsuario, "informacion": self.tfInformacion.text ?? ""])

                        let homeViewController = self.storyboard?.instantiateViewController(identifier: Constantes.Storyboard.homeViewController) as? HomeViewController
                        self.view.window?.rootViewController = homeViewController
                        self.view.window?.makeKeyAndVisible()
                        
                    }
                    else{
                        self.lbError.text = "Error al registrar la cuenta"
                    }

            }
        }
        else{
            if (tfNombreNegocio.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
                ejecutarSegue = false
                lbError.text = "Introduce el nombre del negocio"
            }
        }
        return ejecutarSegue

    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "registro2_3"{
            let viewR3 = segue.destination as! Registro3ViewController
            viewR3.nombre = self.nombre
            viewR3.apellido = self.apellido
            viewR3.email = self.email
            viewR3.contraseña = self.contraseña
            viewR3.tipoUsuario = self.tipoUsuario
            viewR3.nombreNegocio = tfNombreNegocio.text!
            
            if (tfInformacion.text == placeholder){
                tfInformacion.text = ""
            }
            viewR3.informacion = tfInformacion.text!
            lbError.text = ""
        }
        
    }
}
