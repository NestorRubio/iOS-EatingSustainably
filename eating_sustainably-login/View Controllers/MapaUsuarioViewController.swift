//
//  MapaUsuarioViewController.swift
//  eating_sustainably-login
//
//  Created by Enrique Elizondo on 5/16/21.
//

import UIKit
import CoreLocation
import MapKit

class MapaUsuarioViewController: UIViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate: Bool {
        return false
    }
    
    @IBOutlet weak var mapaUsuario: MKMapView!
    
    var usuarioVerPerfil : Usuario!
    var ver : Bool = false
    var lat : Double!
    var lon : Double!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Guarda la direccion del usuario
        let locUsuario = MKPointAnnotation()
        
        if (self.ver == true){
            // Latitud y Longitud de usuario
            lat = usuarioVerPerfil.m_latitud!
            lon = usuarioVerPerfil.m_longitud!
        }
        else {
            // Latitud y Longitud de usuario
            lat = Constantes.usuario.m_latitud!
            lon = Constantes.usuario.m_longitud!
        }

        
        // Usa las coordenadas para guardar la direccion
        locUsuario.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        // Agrega la localizacion del usuario al mapa
        mapaUsuario.addAnnotation(locUsuario)
        
        // Se usa para que el mapa tenga zoom hacia la direcion del usuario
        let region = MKCoordinateRegion(center: locUsuario.coordinate, latitudinalMeters: 400, longitudinalMeters: 400)
        
        // Titulo del pin en la direccion del usuario
        if (self.ver == true){
            locUsuario.title = usuarioVerPerfil.m_negocio!
        }
        else {
            locUsuario.title = Constantes.usuario.m_negocio!
        }
        //
        mapaUsuario.setRegion(region, animated: true)
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
