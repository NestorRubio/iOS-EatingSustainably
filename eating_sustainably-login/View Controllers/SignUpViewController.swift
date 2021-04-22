//
//  SignUpViewController.swift
//  eating_sustainably-login
//
//  Created by user190188 on 4/21/21.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var tfNombre: UITextField!
    
    @IBOutlet weak var tfApellido: UITextField!
    
    @IBOutlet weak var tfEmail: UITextField!
    
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var tfUserType: UITextField!
    
    @IBOutlet weak var bttnRegistro: UIButton!
    
    @IBOutlet weak var lbError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        lbError.alpha = 0
    }
    

    func validateFileds() -> String? {
        
        //revisar que todos loc campos esten llenos
        if tfNombre.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            tfApellido.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Favor de llenar todos los campos"
        }
        //revisar que contraseña sea segura
        let cleanedPassword = tfPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        return nil
    }

    @IBAction func registroTap(_ sender: Any) {
        
        //validar campos
        let error = validateFileds()
        
        if (error != nil){
            showError(error!)
        }else{
            //limpiar datos
            let nombre = tfNombre.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let apellido = tfApellido.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = tfEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = tfPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let tipoUsuario = tfUserType.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            //crear usuario
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                if err != nil{
                    //Error al crear usuario
                    self.showError("Error al crear usuario")
                }else{
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["nombre":nombre, "apellido":apellido, "tipoUsuario": tipoUsuario,"uid":result!.user.uid ]) { (error) in
                        if error != nil{
                            self.showError("No se capturaron datos: nombre, apellido, tipo de usuario")
                        }
                    }
                    //regreso a home
                    self.transitionToHome()
                }
            }
        }
        //crear usuario
    }
    func showError(_ message:String){
        lbError.text = message
        lbError.alpha = 1
    }
    
    func transitionToHome(){
        let homeViewController = storyboard?.instantiateViewController(identifier: Constantes.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
}
