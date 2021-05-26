//
//  ModificarPasswordViewController.swift
//  eating_sustainably-login
//
//  Created by user189360 on 5/15/21.
//

import UIKit
import FirebaseAuth

class ModificarPasswordViewController: UIViewController {
    
    var usuarioVerPerfil : Usuario!
    var ver : Bool = false
    
    @IBOutlet weak var lbContraseñaAct: UILabel!
    @IBOutlet weak var tfContraseñaAct: UITextField!
    
    
    @IBOutlet weak var lbNewPassword: UILabel!
    @IBOutlet weak var tfNewPassword: UITextField!
    
    
    @IBOutlet weak var lbNewPasswordConf: UILabel!
    @IBOutlet weak var tfNewPasswordConf: UITextField!
    
    
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var tfEmail: UITextField!
    
    @IBOutlet weak var bttnChangePassword: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Modificar contraseña"

        // Do any additional setup after loading the view.
    }
    
    func changePassword(email : String, currentPassword : String, newPassword : String, completion: @escaping (Error) -> Void){
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: {(result, error) in
            if let error = error{
                completion(error)
            }else{
                Auth.auth().currentUser?.updatePassword(to: newPassword, completion: {(error) in
                    print("error")
                })
            }
        })
    }
    
    @IBAction func cambiarContraseña(_ sender: UIButton) {
  
        if(tfNewPassword.text! == tfNewPasswordConf.text!){
            
            self.changePassword(email: tfEmail.text!, currentPassword: tfContraseñaAct.text!, newPassword: tfNewPassword.text!, completion: {(error) in
                if error == nil{
        
                    let alertController = UIAlertController(title: "Error", message: "No se pudo actualizar la contraseña. Intentelo de nuevo", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Entendido", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                }else{
                    let alertController = UIAlertController(title: "Exito!", message: "Contraseña actualizada correctamente", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Entendido", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                }
            })
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
