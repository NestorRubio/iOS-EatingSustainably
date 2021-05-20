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
    
    @IBOutlet weak var mapaUsuario: MKMapView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Guarda la direccion del usuario
        let locUsuario = MKPointAnnotation()
        
        // Latitud y Longitud de usuario
        let lat = Constantes.usuario.m_latitud!
        let lon = Constantes.usuario.m_longitud!
        
        // Usa las coordenadas para guardar la direccion
        locUsuario.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        // Agrega la localizacion del usuario al mapa
        mapaUsuario.addAnnotation(locUsuario)
        
        // Se usa para que el mapa tenga zoom hacia la direcion del usuario
        let region = MKCoordinateRegion(center: locUsuario.coordinate, latitudinalMeters: 400, longitudinalMeters: 400)
        
        // Titulo del pin en la direccion del usuario
        locUsuario.title = Constantes.usuario.m_negocio!
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
