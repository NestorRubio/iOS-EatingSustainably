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
    
    
    @IBOutlet weak var lbValidar: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Información Adicional"
        
        //ocultamos los campos segun el tipo de usuario
        if (Constantes.usuario.m_tipo == Constantes.USER_CONSUMIDOR || Constantes.usuario.m_tipo == Constantes.USER_INGENIERO){
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
        
        if (Constantes.usuario.m_tipo == Constantes.USER_CONSUMIDOR || Constantes.usuario.m_tipo == Constantes.USER_INGENIERO){
            
            //creamos usuario firebase
            Auth.auth().createUser(withEmail: Constantes.usuario.m_email!, password: self.contraseña!) { result, error in
                if error != nil, let error = error as NSError?{
                    if let errorCode = AuthErrorCode(rawValue: error.code) {
                        switch errorCode {
                        case .invalidEmail:
                            self.present(mostrarMsj(error: Constantes.FIREBASE_MAIL), animated: true, completion: nil)
                            break
                        case .emailAlreadyInUse:
                            self.present(mostrarMsj(error: Constantes.FIREBASE_MAIL_REPETIDO), animated: true, completion: nil)
                            break
                        case .weakPassword:
                            self.present(mostrarMsj(error: Constantes.FIREBASE_PASSWORD), animated: true, completion: nil)
                            break
                        default:
                            self.present(mostrarMsj(error: Constantes.DEFAULT), animated: true, completion: nil)
                            break
                        }
                    }
                    else{
                        self.present(mostrarMsj(error: Constantes.DEFAULT), animated: true, completion: nil)
                    }
                }
                else {
                    //guardamos id
                    Constantes.usuario.m_uid = result!.user.uid
                    
                    //limpiamos placeholder si no ha puesto nada
                    if (self.tfInformacion.text == self.placeholder){
                        self.tfInformacion.text = ""
                    }
                    
                    //el registro en firebase es correcto guardamos usuario en base de datos
                    Constantes.db.collection("users").document(result!.user.uid).setData(["nombre": Constantes.usuario.m_nombre!, "apellido":Constantes.usuario.m_apellido!, "email":Constantes.usuario.m_email!, "tipoUsuario":Constantes.usuario.m_tipo!, "informacion": self.tfInformacion.text!])
                    
                    let homeViewController = self.storyboard?.instantiateViewController(identifier: Constantes.Storyboard.homeViewController) as? HomeViewController
                    self.view.window?.rootViewController = homeViewController
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
        else{
            if (tfNombreNegocio.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
                self.present(mostrarMsj(error: Constantes.NOMBRE_NEGOCIO), animated: true, completion: nil)
            }
            else{
                //es usuario vendedor y no hay errores podemos continuar
                return true
            }
        }
        return false

    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "registro2_3"{
            let viewR3 = segue.destination as! Registro3ViewController
            viewR3.contraseña = self.contraseña
            viewR3.nombreNegocio = tfNombreNegocio.text!
            
            if (tfInformacion.text == placeholder){
                tfInformacion.text = ""
            }
            viewR3.informacion = tfInformacion.text!
        }
        
    }
}
