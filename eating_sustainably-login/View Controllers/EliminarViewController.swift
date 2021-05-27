//
//  EliminarViewController.swift
//  eating_sustainably-login
//
//  Created by user189360 on 5/15/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class EliminarViewController: UIViewController {
    
    var usuarioVerPerfil : Usuario!
    var ver : Bool = false
    
    @IBOutlet weak var lbCorreo: UILabel!
    @IBOutlet weak var tfCorreo: UITextField!
    @IBOutlet weak var lbPassword: UILabel!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var bttnDelAccount: UIButton!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Eliminar usuario"
        
        if ver == true{
            lbCorreo.isHidden = true
            tfCorreo.isHidden = true
            lbPassword.isHidden = true
            tfPassword.isHidden = true
        }else{
            lbCorreo.isHidden = false
            tfCorreo.isHidden = false
            lbPassword.isHidden = false
            tfPassword.isHidden = false
        }
        

        // Do any additional setup after loading the view.
        let alertController = UIAlertController(title: "Aviso", message: "Una vez eliminada una cuenta, esta no podra ser recuperada. ", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Entendido", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func cerrarSesion(alert : UIAlertAction!){
        
        let portada = self.storyboard?.instantiateViewController(identifier: Constantes.Storyboard.portadaViewController) as? UINavigationController
        self.view.window?.rootViewController = portada
        self.view.window?.makeKeyAndVisible()
            //mostramos mensajes de confirmacion y vamos a portada
    }
    
    func deleteAccount(email : String, currentPassword : String, completion: @escaping (Error) -> Void){
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: {(result, error) in
            if let error = error{
                let alertController = UIAlertController(title: "Error", message: "Credenciales incorrectas", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Entendido", style: .default))
                self.present(alertController, animated: true, completion: nil)
                completion(error)
            }else{
                let user = Auth.auth().currentUser
                user?.delete { error in
                    if error != nil{
                        let alertController = UIAlertController(title: "Error", message: "No se pudo eliminar la cuenta. Intentelo de nuevo", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Entendido", style: .default))
                        self.present(alertController, animated: true, completion: nil)
                    }else{
                        let alertController = UIAlertController(title: "Exito!", message: "La cuenta ha sido eliminada correctamente", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Entendido", style: .default, handler: self.cerrarSesion ))
                        self.present(alertController, animated: true, completion: nil)

                    }
                }
            }
        })
    }
    
    func regresar(action : UIAlertAction){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func borrarCuenta(_ sender: UIButton) {
        if ver == true {
            usuarioVerPerfil.m_estado = 3
            db.collection("users").document(usuarioVerPerfil.m_uid!).setData(["estado" : 3], merge: true)
            let alertController = UIAlertController(title: "Aviso", message: "El usuario ha sido eliminado", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Entendido", style: .default, handler: regresar))
            self.present(alertController, animated: true, completion: nil)
        }else{
            deleteAccount(email: tfCorreo.text!, currentPassword: tfPassword.text!){(error) in
                if error == nil{
                    print("error")
                }else{
                    print("exito")
                }
            }
        }
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
