//
//  Registro2ViewController.swift
//  eating_sustainably-login
//
//  Created by user189360 on 4/21/21.
//

import UIKit
import FirebaseAuth

class Registro2ViewController: UIViewController, UITextViewDelegate {
    
    var contraseña : String?
    var validar: Bool = false
    var usuarioValidar: Usuario!
    
    @IBOutlet weak var tfNombreNegocio: UITextField!
    @IBOutlet weak var tfInformacion: UITextView!
    @IBOutlet weak var btnVideo: UIButton!
    @IBOutlet weak var btnContinuar: UIButton!
    @IBOutlet weak var lbValidar: UILabel!

    var placeholder : String = "Escribe tu historia personal"

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
        
        if (!validar){
            lbValidar.isHidden = true
        }
        else {
            tfNombreNegocio.text = usuarioValidar.m_negocio
            tfNombreNegocio.isEnabled = false
            
            tfInformacion.text = usuarioValidar.m_informacion
            tfInformacion.isEditable = false
            
            btnVideo.isEnabled = false
        }
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
        if (!self.validar){
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

                        if (self.tfInformacion.text == self.placeholder){
                            self.tfInformacion.text = ""
                        }
                        //guardamos datos en variable usuario
                        Constantes.usuario.m_uid = result!.user.uid
                        Constantes.usuario.m_informacion = self.tfInformacion.text!
                        Constantes.usuario.m_negocio = self.tfNombreNegocio.text!


                        //el registro en firebase es correcto guardamos usuario en base de datos
                        Constantes.db.collection("users").document(result!.user.uid).setData(["nombre": Constantes.usuario.m_nombre!, "apellido":Constantes.usuario.m_apellido!, "email":Constantes.usuario.m_email!, "tipo":Constantes.usuario.m_tipo!, "informacion": self.tfInformacion.text!,"foto":""])
                        
                        let homeViewController = self.storyboard?.instantiateViewController(identifier: Constantes.Storyboard.homeViewController) as? UITabBarController
                        
                        //mostramos mensajes de confirmacion y vamos a home cuando el usuario acepta
                        self.present(mostrarMsj(error: Constantes.REGISTRO_OK, hand: {(action) -> Void in self.view.window?.rootViewController = homeViewController
                                                    self.view.window?.makeKeyAndVisible()}), animated: true, completion: nil)

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
        }
        //estamos validando
        else{
            return true
        }
        
        return false
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "registro2_3"{
            
            if (self.tfInformacion.text == self.placeholder){
                self.tfInformacion.text = ""
            }
            
            Constantes.usuario.m_informacion = self.tfInformacion.text!
            Constantes.usuario.m_negocio = self.tfNombreNegocio.text!

            let viewR3 = segue.destination as! Registro3ViewController
            viewR3.contraseña = self.contraseña
            viewR3.validar = self.validar
            viewR3.usuarioValidar = self.usuarioValidar


        }
    }
}
