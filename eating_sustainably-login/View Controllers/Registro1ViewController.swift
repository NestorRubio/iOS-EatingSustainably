//
//  SignUpViewController.swift
//  eating_sustainably-login
//
//  Created by user190188 on 4/21/21.
//

import UIKit
import FirebaseAuth
import Firebase
import iOSDropDown

class Registro1ViewController: UIViewController {
    
    var validar: Bool = false
    var usuarioValidar: Usuario!
    
    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tfApellido: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var dropDownUserType: DropDown!
    @IBOutlet weak var bttnRegistro: UIButton!
    @IBOutlet weak var lbValidar: UILabel!
    
    //tipo de usuario seleccionado
    var tipoUsuario:Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Información básica"
        bttnRegistro.layer.cornerRadius = 8
        
        //variable auxiliar para las ids
        var optIds : [Int] = []
        //bucle para tipo de usuarios que hay, el 0 es admin lo saltamos
        for i in 1 ... Constantes.USER_TOTAL{
            dropDownUserType.optionArray.append(getUserStringName(users: i))
            optIds.append(i)
        }
        dropDownUserType.optionIds = optIds

        dropDownUserType.didSelect{(selectedText , index ,id) in
            self.tipoUsuario = id
        }
        if (!validar){
            lbValidar.isHidden = true
        }
        else {
            tfNombre.text = usuarioValidar.m_nombre
            tfNombre.isEnabled = false
            
            tfApellido.text = usuarioValidar.m_apellido
            tfApellido.isEnabled = false
            
            tfEmail.text = usuarioValidar.m_email
            tfEmail.isEnabled = false
            
            tfPassword.isHidden = true
            
            dropDownUserType.text = getUserStringName(users: usuarioValidar.m_tipo!)
            dropDownUserType.isEnabled = false
        }
        
    }


    func validateFileds() -> Int? {
        
        //revisar que todos loc campos esten llenos
        if (tfNombre.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || tfApellido.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            return Constantes.USERNAME
        }
        if (tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || !isValidPattern(tfEmail.text ?? "", tipo: Constantes.MAIL)) {
            return Constantes.MAIL
        }
        if (tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || !isValidPattern(tfPassword.text ?? "", tipo: Constantes.PASSWORD)) {
            return Constantes.PASSWORD
        }
        if (tipoUsuario <= Constantes.USER_ADMIN || tipoUsuario >= Constantes.USER_TOTAL) {
            return Constantes.TIPO_USER
        }
        return nil
    }
    

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (!self.validar){
            let errorDatos = validateFileds()
            
            //error en un campo introducido
            if (errorDatos != nil){
                present(mostrarMsj(error: errorDatos!), animated: true, completion: nil)
            }
            else{
                //limpiar datos
                let email = tfEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                let password = tfPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                
                //creamos usuario firebase
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
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
                        //el registro en firebase es correcto guardamos usuario
                        Constantes.usuario = Usuario(nombre: self.tfNombre.text!, apellido: self.tfApellido.text!, email: self.tfEmail.text!, tipo: self.tipoUsuario, uid: "", foto: "", video: "")
                        //eliminamos cuenta de firebase hasta finalizar el proceso
                        Constantes.auth.currentUser?.delete { error in
                            if error == nil {
                                //llamamos al segue si todo es correcto
                                self.performSegue(withIdentifier: "registro1_2", sender: self)
                            }
                        }
                    }
                }
            }
        }
        //estamos validando
        else {
            return true
        }
       
        return false
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "registro1_2"{
            let viewR2 = segue.destination as! Registro2ViewController
            viewR2.contraseña = tfPassword.text!
            viewR2.validar = self.validar
            viewR2.usuarioValidar = self.usuarioValidar
        }
    }
}
