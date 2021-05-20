//
//  SplashViewController.swift
//  eating_sustainably-login
//
//  Created by user189360 on 5/12/21.
//

import UIKit

class SplashViewController: UIViewController {
    

    @IBOutlet weak var lbTitulo: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbTitulo.text = Constantes.NOMBRE_APP
    
        
    
        // Do any additional setup after loading the view.
        Constantes.auth.addStateDidChangeListener { auth, user in
            if let user = user {
                if (Constantes.load == false){
                    Constantes.db.collection("users").document(Constantes.auth.currentUser!.uid).getDocument { (documentSnapshot, error) in
                        if let document = documentSnapshot, document.exists {

                            //Cargamos los datos de usuario en el objeto
                            Constantes.usuario = Usuario(nombre: document.get("nombre") as? String, apellido: document.get("apellido") as? String, email: document.get("email") as? String, tipo: document.get("tipo") as? Int, uid: document.documentID, foto: document.get("foto") as? String, info: document.get("informacion") as? String)
                            
                            if (Constantes.usuario.m_foto! != ""){
                                let task = URLSession.shared.dataTask(with: URL(string: Constantes.usuario.m_foto!)!, completionHandler: {data, _, error in
                                    DispatchQueue.main.async {
                                        if error == nil, let data = data {
                                            Constantes.usuario.m_imagen = UIImage(data: data)
                                        }
                                        else {
                                            Constantes.usuario.m_foto = ""
                                        }
                                    }

                                })
                                task.resume()
                            }

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
                            Constantes.load = true

                            sleep(1)
                            let homeViewController = self.storyboard?.instantiateViewController(identifier: Constantes.Storyboard.homeViewController) as? UITabBarController
                            self.view.window?.rootViewController = homeViewController
                            self.view.window?.makeKeyAndVisible()
                        }
                        else{
                            //mensaje de error y cerramos la app
                            self.present(mostrarMsj(error: Constantes.DEFAULT, hand: {(action) -> Void in
                            //deslogeamos usuario que ha causado error
                            do {
                                try Constantes.auth.signOut()
                                exit(0)
                            }
                            catch let signOutError as NSError {
                                //print ("Error signing out: %@", signOutError)
                            }}), animated: true, completion: nil)
                        }
                    }

                }
            }
            else {
                Constantes.load = true

                sleep(1)
                let homeViewController = self.storyboard?.instantiateViewController(identifier: Constantes.Storyboard.portadaViewController) as? UINavigationController
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
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
