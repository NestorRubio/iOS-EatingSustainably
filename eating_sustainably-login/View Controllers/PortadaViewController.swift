//
//  ViewController.swift
//  eating_sustainably-login
//
//  Created by user190188 on 4/21/21.
//

import UIKit

class PortadaViewController: UIViewController {
    
  
    @IBOutlet weak var lbTituloApp: UILabel!
    @IBOutlet weak var btnIniciarSesion: UIButton!
    @IBOutlet weak var btnRegistrarse: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // titulo y nombre app
        title = "Binvenido a \(Constantes.NOMBRE_APP)!"
        lbTituloApp.text = Constantes.NOMBRE_APP
        
        //borde botones
        btnIniciarSesion.layer.cornerRadius = 8
        btnRegistrarse.layer.cornerRadius = 8
        
        if (Constantes.auth.currentUser != nil){
            let homeViewController = self.storyboard?.instantiateViewController(identifier: Constantes.Storyboard.homeViewController) as? HomeViewController
            self.view.window?.rootViewController = homeViewController
            self.view.window?.makeKeyAndVisible()            
        }

        
        
    }


}

