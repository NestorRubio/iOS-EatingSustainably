//
//  HomeViewController.swift
//  eating_sustainably-login
//
//  Created by user189360 on 4/21/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var btnValidar: UIBarButtonItem!
    @IBOutlet weak var btnBuscar: UIBarButtonItem!
    @IBOutlet weak var btnCerrar: UIBarButtonItem!
    


    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Feed general"
        //title = Constantes.usuario.m_email
        
        btnValidar.title = "Validar"

        btnBuscar.image = UIImage(systemName: "magnifyingglass")
        btnBuscar.tintColor = .black

        btnCerrar.image = UIImage(systemName: "power")
        btnCerrar.tintColor = .red
        

        // Do any additional setup after loading the view.
        
        if (Constantes.usuario.m_tipo == Constantes.USER_ADMIN){
            btnValidar.isEnabled = true
            navigationItem.rightBarButtonItems = [btnCerrar, btnBuscar, btnValidar]
        }
        else {
            btnValidar.isEnabled = false
            navigationItem.rightBarButtonItems = [btnCerrar, btnBuscar]
        }
        
    }
    
    
    @IBAction func cerrarSesion(_ sender: UIBarButtonItem) {
        do {
            try Constantes.auth.signOut()
        
            let portada = self.storyboard?.instantiateViewController(identifier: Constantes.Storyboard.portadaViewController) as? UINavigationController
            
            //mostramos mensajes de confirmacion y vamos a portada cuando el usuario acepta
            self.present(mostrarMsj(error: Constantes.CERRAR_OK, hand: {(action) -> Void in self.view.window?.rootViewController = portada
                                        self.view.window?.makeKeyAndVisible()}), animated: true, completion: nil)
        }
        catch let signOutError as NSError {
            self.present(mostrarMsj(error: Constantes.ERROR_CERRAR), animated: true, completion: nil)
        }
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "home_buscador"{
            let viewBuscador = segue.destination as! BuscadorFeedViewController
        }
        else if segue.identifier == "home_validar"{
            let viewValidar = segue.destination as! ListaValidarTableViewController 
        }
    }


}
