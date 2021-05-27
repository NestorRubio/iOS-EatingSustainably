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
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate: Bool {
        return false
    }
    
    var usuarioVerPerfil : Usuario!
    var ver : Bool = false
    
    @IBOutlet weak var lbCorreo: UILabel!
    @IBOutlet weak var tfCorreo: UITextField!
    @IBOutlet weak var lbPassword: UILabel!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var bttnDelAccount: UIButton!
    
    var msg : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Eliminar usuario"
        
        if ver == true{
            lbCorreo.isHidden = true
            tfCorreo.isHidden = true
            lbPassword.isHidden = true
            tfPassword.isHidden = true
            msg = "Estás a punto de eliminar la cuenta de " + usuarioVerPerfil.m_email!
        }
        else{
            lbCorreo.isHidden = false
            tfCorreo.isHidden = false
            lbPassword.isHidden = false
            tfPassword.isHidden = false
            msg = "Estás a punto de eliminar tu cuenta de usuario"
        }
        
        
        // Do any additional setup after loading the view.
        let alertController = UIAlertController(title: "Aviso", message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Entendido", style: .default))
        self.present(alertController, animated: true, completion: nil)
 
    }
    
    @IBAction func quitaTeclado(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func deleteAccount(email : String, currentPassword : String, completion: @escaping (Error) -> Void){
        
        if (email.trimmingCharacters(in: .whitespacesAndNewlines) == "" || !isValidPattern(email, tipo: Constantes.MAIL)) {
            present(mostrarMsj(error: Constantes.MAIL), animated: true, completion: nil)
        }
        else{//ok email
            if (email != Constantes.usuario.m_email){
                present(mostrarMsj(error: Constantes.ERROR_EMAIL), animated: true, completion: nil)
            }
            else{
                if (currentPassword.trimmingCharacters(in: .whitespacesAndNewlines) == "" || !isValidPattern(currentPassword, tipo: Constantes.PASSWORD)) {
                    present(mostrarMsj(error: Constantes.PASSWORD), animated: true, completion: nil)
                }
                else{//ok password
                    let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
                    
                    Constantes.auth.currentUser?.reauthenticate(with: credential, completion: {(result, error) in
                        if let error = error{
                            let alertController = UIAlertController(title: "Error", message: "Credenciales incorrectas", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "Entendido", style: .default))
                            self.present(alertController, animated: true, completion: nil)
                            completion(error)
                        }
                        else{//reautentificacion ok
                            
                            //cambio de estado de la cuenta
                            Constantes.db.collection("users").document(Constantes.usuario.m_uid!).updateData(["estado": Constantes.CUENTA_ELIMINADA]){ [self] err in
                                if let err = err {
                                    //error actualizar fireabse
                                    self.present(mostrarMsj(error: Constantes.ERROR_ELIMINAR), animated: true, completion: nil)
                                }
                                else {
                                    //deslogeamos el usuario creado
                                    do {
                                        try Constantes.auth.signOut()
                                    }
                                    catch let signOutError as NSError {
                                        self.present(mostrarMsj(error: Constantes.DEFAULT), animated: true, completion: nil)
                                    }
                                    let portada = self.storyboard?.instantiateViewController(identifier: Constantes.Storyboard.portadaViewController) as? UINavigationController
                                    Constantes.usuario = Usuario()

                                    //mostramos mensajes de confirmacion y vamos a portada cuando el usuario acepta
                                    self.present(mostrarMsj(error: Constantes.ELIMINAR_OK, hand: {(action) -> Void in self.view.window?.rootViewController = portada
                                    self.view.window?.makeKeyAndVisible()}), animated: true, completion: nil)
                                }
                            }
                            
                            /*Constantes.auth.currentUser?.delete { error in
                                if error != nil{
                                    let alertController = UIAlertController(title: "Error", message: "No se pudo eliminar la cuenta. Intentelo de nuevo", preferredStyle: .alert)
                                    alertController.addAction(UIAlertAction(title: "Entendido", style: .default))
                                    self.present(alertController, animated: true, completion: nil)
                                }else{
                                    let alertController = UIAlertController(title: "Exito!", message: "La cuenta ha sido eliminada correctamente", preferredStyle: .alert)
                                    alertController.addAction(UIAlertAction(title: "Entendido", style: .default, handler: self.cerrarSesion ))
                                    self.present(alertController, animated: true, completion: nil)
                                }
                            }*/
                        }
                    })
                }
            }
        }
    }
    
    func regresar(action : UIAlertAction){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func borrarCuenta(_ sender: UIButton) {
        if ver == true {
            usuarioVerPerfil.m_estado = Constantes.CUENTA_ELIMINADA

            Constantes.db.collection("users").document(usuarioVerPerfil.m_uid!).updateData(["estado": Constantes.CUENTA_ELIMINADA]){ [self] err in
                if let err = err {
                    //error actualizar fireabse
                    self.present(mostrarMsj(error: Constantes.ERROR_ELIMINAR), animated: true, completion: nil)
                }
                else {
                    //adminn eliminado cuenta
                    //mensaje de confirmación
                    let portada = self.storyboard?.instantiateViewController(identifier: Constantes.Storyboard.homeViewController) as? UITabBarController
                        
                    //mostramos mensajes de confirmacion y vamos a portada cuando el usuario acepta
                    self.present(mostrarMsj(error: Constantes.ELIMINAR_OK, hand: {(action) -> Void in self.view.window?.rootViewController = portada
                    self.view.window?.makeKeyAndVisible()}), animated: true, completion: nil)
                }
            }
        }
        else{
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
