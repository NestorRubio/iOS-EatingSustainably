//
//  ViewController.swift
//  eating_sustainably-login
//
//  Created by user190188 on 4/21/21.
//

import UIKit
import AppTrackingTransparency

class PortadaViewController: UIViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate: Bool {
        return false
    }
    
  
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
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "portada_login"{
            let viewBuscar = segue.destination as! LogInViewController
        }
        else if segue.identifier == "portada_registro"{
            
            ATTrackingManager.requestTrackingAuthorization{ status in
                switch status{
                
                case .notDetermined:
                    break
                case .restricted:
                    break
                case .denied:
                    break
                case .authorized:
                    let viewBuscar = segue.destination as! Registro1ViewController
                    break
                @unknown default:
                    break
                }
            }
        }
        else if segue.identifier == "portada_buscar"{
            let viewBuscar = segue.destination as! BuscarViewController
        }
        else if segue.identifier == "portada_soporte"{
            let viewSoporte = segue.destination as! ViewControllerFAQ
        }
    }
    
}




