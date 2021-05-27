//
//  LogInViewController.swift
//  eating_sustainably-login
//
//  Created by user190188 on 4/21/21.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate: Bool {
        return false
    }
    
    @IBOutlet weak var tfEmail: UITextField!
    
    
    @IBOutlet weak var tfPassword: UITextField!
    
    
    @IBOutlet weak var bttnInicioSesion: UIButton!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Iniciar sesión"
        bttnInicioSesion.layer.cornerRadius = 8

        // Do any additional setup after loading the view.
    }
    
   
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

    
    @IBAction func loginTap(_ sender: Any) {
        //validate textfields
        let mail = tfEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = tfPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //comprobar email
        if (tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" || isValidPattern(tfEmail.text ?? "", tipo: Constantes.MAIL)) {
            //comprobar password
            if (tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" || isValidPattern(tfPassword.text ?? "", tipo: Constantes.PASSWORD)) {
                
                //signin
                Constantes.auth.signIn(withEmail: mail, password: password) { (result, error) in
                    //error en el login
                    if error != nil, let error = error as NSError?{
                        if let errorCode = AuthErrorCode(rawValue: error.code) {
                            switch errorCode {
                            case .invalidEmail:
                                self.present(mostrarMsj(error: Constantes.MAIL), animated: true, completion: nil)
                                break
                            case .userDisabled:
                                self.present(mostrarMsj(error: Constantes.FIREBASE_BLOCK), animated: true, completion: nil)
                                break
                            case .wrongPassword:
                                self.present(mostrarMsj(error: Constantes.FIREBASE_PASSWORD), animated: true, completion: nil)
                                break
                            case .userNotFound:
                                self.present(mostrarMsj(error: Constantes.FIREBASE_MAIL), animated: true, completion: nil)
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
                    //login correcto
                    else {
                        //cargamos los datos
                        Constantes.db.collection("users").document(result?.user.uid ?? "ERROR").getDocument { (documentSnapshot, error) in
                            if let document = documentSnapshot, document.exists {
                                //estado del usuario valido podemos logear
                                if (document.get("estado") as? Int == 0){
                                    //Cargamos los datos de usuario en el objeto
                                    Constantes.usuario = Usuario(nombre: document.get("nombre") as? String, apellido: document.get("apellido") as? String, email: document.get("email") as? String, tipo: document.get("tipo") as? Int, uid: document.documentID, foto: document.get("foto") as? String, info: document.get("informacion") as? String, estado: document.get("estado") as? Int)
                                        //si es tipo vendedor cargamos datos adicionales
                                        if (document.get("tipo") as? Int == Constantes.USER_TENDERO || document.get("tipo") as? Int == Constantes.USER_AGRICULTOR || document.get("tipo") as? Int == Constantes.USER_RESTAURANTERO){
                                            
                                            Constantes.usuario.m_latitud = document.get("latitud") as? Double
                                            Constantes.usuario.m_longitud = document.get("longitud") as? Double
                                            Constantes.usuario.m_negocio = document.get("negocio") as? String
                                            Constantes.usuario.m_proceso = document.get("proceso") as? String
                                            Constantes.usuario.m_categorias = document.get("categorias") as! [Int]
                                            Constantes.usuario.m_video = document.get("video") as? String
                                            Constantes.usuario.m_telefono = document.get("telefono") as? String
                                        }
                                            
                                        if (Constantes.usuario.m_foto! != ""){
                                            Constantes.storage.child(Constantes.usuario.m_foto!).getData(maxSize: 1 * 1024 * 1024) { data, error in
                                                if let error = error {
                                                    Constantes.usuario.m_foto = ""
                                                }
                                                else {
                                                    Constantes.usuario.m_imagen = UIImage(data: data!)
                                                }
                                            }
                                        }
                                    let homeViewController = self.storyboard?.instantiateViewController(identifier: Constantes.Storyboard.homeViewController) as? UITabBarController
                                    self.view.window?.rootViewController = homeViewController
                                    self.view.window?.makeKeyAndVisible()
                                            
                                }
                                else {
                                    switch document.get("estado") as? Int {
                                    case Constantes.CUENTA_POR_VALIDAR:
                                        self.present(mostrarMsj(error: Constantes.VALIDAR), animated: true, completion: nil)
                                        break
                                    case Constantes.CUENTA_BLOQUEADA:
                                        self.present(mostrarMsj(error: Constantes.BLOQUEADA), animated: true, completion: nil)
                                        break
                                    case Constantes.CUENTA_ELIMINADA:
                                        self.present(mostrarMsj(error: Constantes.ELIMINADA), animated: true, completion: nil)
                                        break

                                    default:
                                        self.present(mostrarMsj(error: Constantes.DEFAULT), animated: true, completion: nil)
                                        break
                                    }
                                }
                            }
                            else {//no encuentra el documento pero si deberia existir
                                self.present(mostrarMsj(error: Constantes.DEFAULT), animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
            else{
                present(mostrarMsj(error: Constantes.PASSWORD), animated: true, completion: nil)
            }
        }
        else {
            present(mostrarMsj(error: Constantes.MAIL), animated: true, completion: nil)
        }
    }
}
