//
//  ModificarPasswordViewController.swift
//  eating_sustainably-login
//
//  Created by user189360 on 5/15/21.
//

import UIKit
import FirebaseAuth

class ModificarPasswordViewController: UIViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate: Bool {
        return false
    }
    
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
    
    func changePassword(email : String, currentPassword : String, newPassword : String){
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)

        Auth.auth().currentUser?.reauthenticate(with: credential, completion: {(result, error) in
            if let error = error{
                self.present(mostrarMsj(error: Constantes.FIREBASE_PASSWORD), animated: true, completion: nil)
            }
            else{
                Auth.auth().currentUser?.updatePassword(to: newPassword, completion: {(error) in
                    if let error = error{
                        self.present(mostrarMsj(error: Constantes.ERROR_ACTUALIZAR_PASSWORD), animated: true, completion: nil)
                    }
                    else {
                        self.present(mostrarMsj(error: Constantes.ACTUALIZAR_PASSWORD_OK, hand: {(action) -> Void in self.navigationController?.popViewController(animated: true)}), animated: true, completion: nil)
                    }
                })
            }
        })
    }
    
    @IBAction func quitaTeclado(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    @IBAction func cambiarContraseña(_ sender: UIButton) {
        if (tfEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" || !isValidPattern(tfEmail.text!, tipo: Constantes.MAIL)) {
            present(mostrarMsj(error: Constantes.MAIL), animated: true, completion: nil)
        }
        else{//ok email1
            if (tfEmail.text! != Constantes.usuario.m_email){
                present(mostrarMsj(error: Constantes.ERROR_EMAIL), animated: true, completion: nil)
            }
            else{//ok email2
                if (tfContraseñaAct.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" || !isValidPattern(tfContraseñaAct.text!, tipo: Constantes.PASSWORD) || tfNewPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" || tfNewPasswordConf.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" || !isValidPattern(tfNewPassword.text!, tipo: Constantes.PASSWORD)) {
                    present(mostrarMsj(error: Constantes.PASSWORD), animated: true, completion: nil)
                }
                else{//ok password1
                    if(tfNewPassword.text! != tfNewPasswordConf.text!){
                        present(mostrarMsj(error: Constantes.PASSWORD_COINCIDE), animated: true, completion: nil)
                    }
                    else {//ok password2
                        self.changePassword(email: tfEmail.text!, currentPassword: tfContraseñaAct.text!, newPassword: tfNewPassword.text!)
                    }
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
