//
//  Registro4ViewController.swift
//  eating_sustainably-login
//
//  Created by user189360 on 4/21/21.
//

import UIKit
import FirebaseAuth


class Registro4ViewController: UIViewController {
    
    var nombre : String?
    var apellido : String?
    var email  : String?
    var contraseña : String?
    var tipoUsuario : Int?
    var nombreNegocio: String?
    var informacion: String?
    var sustentable: String?
    var categorias: [Int]?

    @IBOutlet weak var tfTelefono: UITextField!
    @IBOutlet weak var btnRegistrar: UIButton!
    @IBOutlet weak var lbError: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnRegistrar.layer.cornerRadius = 8
        lbError.text = ""
    

    }
    
    func validatePhone(value: String) -> Bool {
            let PHONE_REGEX = "^\\d{2}-\\d{4}-\\d{4}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
            let result = phoneTest.evaluate(with: value)
            return result
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func registrarUsuario(_ sender: UIButton) {
        lbError.text = ""
        
        if (validatePhone(value: self.tfTelefono.text!)){
            
            Auth.auth().createUser(withEmail: self.email!, password: self.contraseña!){
                
                    (result, error) in
                    if let result = result, error == nil{

                        Constantes.db.collection("usersNoValidados").document(result.user.uid).setData(["nombre": self.nombre, "apellido":self.apellido, "email":self.email, "tipoUsuario":self.tipoUsuario, "informacion": self.informacion ?? "", "sustentable":self.sustentable, "negocio":self.nombreNegocio, "categorias":self.categorias, "telefono": self.tfTelefono.text!])

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
            lbError.text = "Introduce un número de teléfono correcto"
        }
    }
    
}
