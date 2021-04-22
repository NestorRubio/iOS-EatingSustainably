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
    
    
    @IBOutlet weak var tfNombre: UITextField!
    
    @IBOutlet weak var tfApellido: UITextField!
    
    @IBOutlet weak var tfEmail: UITextField!
    
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var dropDownUserType: DropDown!
    
    @IBOutlet weak var bttnRegistro: UIButton!
    
    @IBOutlet weak var lbError: UILabel!
    
    var tipoUsuario:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Información básica"
        bttnRegistro.layer.cornerRadius = 8
        
        //bucle para tipo de usuarios que hay, el 0 es admin lo saltamos
        for i in 1 ... Constantes.USER_TOTAL{
            dropDownUserType.optionArray.append(getUserStringName(users: i))
        }
        dropDownUserType.optionIds = [1,2,3,4,5]

        dropDownUserType.didSelect{(selectedText , index ,id) in
            self.tipoUsuario = id
        }
        
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
            tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            self.tipoUsuario == 0 {
            
            return "Favor de llenar todos los campos"
        }
        
        if (isValidEmail(tfEmail.text ?? "") == false){
            return "Formato de e-mail incorrecto"
        }
        //revisar que contraseña sea segura
        let cleanedPassword = tfPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        return nil
    }
    /*
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
            
            
            Constantes.db.collection("users").document(email).getDocument {
            (documentSnapshot, error) in
                    if let document = documentSnapshot, error == nil {
                            self.showError("Error: el email ya está registrado")

                            }
                            
                        }
            
            /*
            //crear usuario
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                if err != nil{
                    //Error al crear usuario
                    self.showError("Error al crear usuario")
                }
            }*/
        }
        //crear usuario
    }
    */
    func showError(_ message:String){
        lbError.text = message
        lbError.alpha = 1
    }
    
    func transitionToHome(){
        let homeViewController = storyboard?.instantiateViewController(identifier: Constantes.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        let error = validateFileds()
        var ejecutarSegue = true
        
        if (error != nil){
            showError(error!)
            ejecutarSegue=false
        }else{
            //limpiar datos
            let nombre = tfNombre.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let apellido = tfApellido.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = tfEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = tfPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            
            Constantes.db.collection("users").document(tfEmail.text!).getDocument {
            (documentSnapshot, error) in
                    if let document = documentSnapshot, error == nil {
                        ejecutarSegue=false
                        self.showError("Error: el email ya está registrado")
                    }
                    else{
                        ejecutarSegue=true
                    }
                }
            
        }
        return ejecutarSegue

    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "registro1_2"{
            let viewR2 = segue.destination as! Registro2ViewController
            viewR2.nombre = tfNombre.text!
            viewR2.apellido = tfApellido.text!
            viewR2.email = tfEmail.text!
            viewR2.contraseña = tfPassword.text!
            viewR2.tipoUsuario = self.tipoUsuario
            self.showError("")
            
        }
        
    }
}
