//
//  EditarPerfilUsuarioViewController.swift
//  eating_sustainably-login
//
//  Created by Enrique Elizondo on 5/16/21.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreLocation

protocol protocoloActualizar{
    func actualizarPerfil(nombre : String, apellido: String, info: String, tlf: String)
}

class EditarPerfilUsuarioViewController: UIViewController, CLLocationManagerDelegate {
    
    var usuarioVerPerfil : Usuario!
    var ver : Bool = false
    
    @IBOutlet weak var lbHistoria: UILabel!
    @IBOutlet weak var lbTelefono: UILabel!

    @IBOutlet weak var tfPrimerNombre: UITextField!
    @IBOutlet weak var tfApellido: UITextField!
    @IBOutlet weak var tfTelefono: UITextField!
    @IBOutlet weak var tvHistoria: UITextView!
    
    @IBOutlet weak var btnUbicacion: UIButton!
    
    
    let locationManager = CLLocationManager()
    var lat:Double?
    var lon:Double?

    var delegado : protocoloActualizar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Editar perfil"
        
        tvHistoria.layer.borderColor = UIColor.lightGray.cgColor
        tvHistoria.layer.borderWidth = 1.0
        
        //caso de admin editando un perfil
        if (ver == true){
            title = "Editando perfil de " + usuarioVerPerfil.m_nombre!
            tfPrimerNombre.text = usuarioVerPerfil.m_nombre!
            tfApellido.text = usuarioVerPerfil.m_apellido!
            tvHistoria.text = usuarioVerPerfil.m_informacion
            
            if (usuarioVerPerfil.m_tipo == Constantes.USER_AGRICULTOR || usuarioVerPerfil.m_tipo == Constantes.USER_TENDERO || usuarioVerPerfil.m_tipo == Constantes.USER_RESTAURANTERO) {
                lbTelefono.isHidden = false
                tfTelefono.isHidden = false
                tfTelefono.text = usuarioVerPerfil.m_telefono!
                lbHistoria.text = "Mi historia"
                //el admin no puede cambiar la ubicacion del usuario
                btnUbicacion.isHidden = true
            }
            else {
                lbTelefono.isHidden = true
                tfTelefono.isHidden = true
                lbHistoria.text = "Información personal"
                btnUbicacion.isHidden = true
            }
        }
        //usuario editando su perfil
        else {
            // Muestra los valores actuales
            tfPrimerNombre.text = Constantes.usuario.m_nombre!
            tfApellido.text = Constantes.usuario.m_apellido!
            tvHistoria.text = Constantes.usuario.m_informacion
            
            if (Constantes.usuario.m_tipo == Constantes.USER_AGRICULTOR || Constantes.usuario.m_tipo == Constantes.USER_TENDERO || Constantes.usuario.m_tipo == Constantes.USER_RESTAURANTERO) {
                lbTelefono.isHidden = false
                tfTelefono.isHidden = false
                tfTelefono.text = Constantes.usuario.m_telefono!
                lbHistoria.text = "Mi historia"
                btnUbicacion.isHidden = false
                btnUbicacion.layer.cornerRadius = 8
                lat = Constantes.usuario.m_latitud
                lon = Constantes.usuario.m_longitud
            }
            else {
                lbTelefono.isHidden = true
                tfTelefono.isHidden = true
                lbHistoria.text = "Información personal"
                btnUbicacion.isHidden = true
            }
        }
    }
    
    
    @IBAction func actualizarUbicacion(_ sender: UIButton) {

        switch locationManager.authorizationStatus {
        
            case .authorizedAlways, .authorizedWhenInUse:
                //tenemos permisos podemos acceder a la localizacion
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.requestLocation()
                break
                
            case .denied:
                //mostramos error de permisos
                self.present(mostrarMsj(error: Constantes.PERMISOS_LOC), animated: true, completion: nil)
                break
            
            case .notDetermined:
                //indeterminado pedimos permisos y accedemos a localizacion
                locationManager.delegate = self
                locationManager.requestAlwaysAuthorization()
                locationManager.requestWhenInUseAuthorization()
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.requestLocation()
                break
            
            case .restricted:
                //mostramos error de permisos
                self.present(mostrarMsj(error: Constantes.PERMISOS_LOC), animated: true, completion: nil)
                break
        @unknown default:
            self.present(mostrarMsj(error: Constantes.PERMISOS_LOC), animated: true, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.lat = location.coordinate.latitude
            self.lon = location.coordinate.longitude
            self.present(mostrarMsj(error: Constantes.UBICACION_ACTU), animated: true, completion: nil)
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        // Handle failure to get a user’s location
    }
    
    
    @IBAction func guardarDatos(_ sender: UIButton) {
        //revisar que todos loc campos correctos
        if (tfPrimerNombre.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || tfApellido.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            present(mostrarMsj(error: Constantes.USERNAME), animated: true, completion: nil)
            return
        }
        
        if (Constantes.usuario.m_tipo == Constantes.USER_AGRICULTOR || Constantes.usuario.m_tipo == Constantes.USER_TENDERO || Constantes.usuario.m_tipo == Constantes.USER_RESTAURANTERO) {
            if (self.tfTelefono.text!.trimmingCharacters(in: .whitespacesAndNewlines) == "" || !isValidPattern(self.tfTelefono.text!, tipo: Constantes.PHONE)) {
                present(mostrarMsj(error: Constantes.PHONE), animated: true, completion: nil)
                return
            }
        }



        var userObjUpdate = [
            "nombre": tfPrimerNombre.text!,
            "nombre_query": tfPrimerNombre.text!.lowercased(),
            "apellido": tfApellido.text!,
            "apellido_query": tfApellido.text!.lowercased(),
            "informacion": tvHistoria.text!,
        ] as [String:Any]
        
        if (Constantes.usuario.m_tipo == Constantes.USER_AGRICULTOR || Constantes.usuario.m_tipo == Constantes.USER_TENDERO || Constantes.usuario.m_tipo == Constantes.USER_RESTAURANTERO) {
            userObjUpdate = [
                "nombre": tfPrimerNombre.text!,
                "nombre_query": tfPrimerNombre.text!.lowercased(),
                "apellido": tfApellido.text!,
                "apellido_query": tfApellido.text!.lowercased(),
                "latitud": lat!,
                "longitud": lon!,
                "telefono": tfTelefono.text!,
                "informacion": tvHistoria.text!,
            ] as [String:Any]
        }
        //admin editando perfil vendedor sin latitud ni longitud
        if (ver == true && (Constantes.usuario.m_tipo == Constantes.USER_AGRICULTOR || Constantes.usuario.m_tipo == Constantes.USER_TENDERO || Constantes.usuario.m_tipo == Constantes.USER_RESTAURANTERO)){
            userObjUpdate = [
                "nombre": tfPrimerNombre.text!,
                "nombre_query": tfPrimerNombre.text!.lowercased(),
                "apellido": tfApellido.text!,
                "apellido_query": tfApellido.text!.lowercased(),
                "telefono": tfTelefono.text!,
                "informacion": tvHistoria.text!,
            ] as [String:Any]
        }
        
        if (ver == true){ //el admin actualiza el perfil del usuario solo en base de datos
            
            Constantes.db.collection("users").document(usuarioVerPerfil.m_uid!).updateData(userObjUpdate){ err in
                if err != nil {
                    //error actualizar fireabse
                    self.present(mostrarMsj(error: Constantes.DEFAULT), animated: true, completion: nil)
                }
                else {
                    //actualizamos datos de la vista anterior
                    self.delegado.actualizarPerfil(nombre: self.tfPrimerNombre.text!, apellido: self.tfApellido.text!, info: self.tvHistoria.text!, tlf: self.tfTelefono.text!)
                    
                    self.present(mostrarMsj(error: Constantes.EDITAR_OK, hand: {(action) -> Void in self.navigationController?.popViewController(animated: true)}),
                            animated: true, completion: nil)
                }
            }
        }
        else {
            Constantes.db.collection("users").document(Constantes.usuario.m_uid!).updateData(userObjUpdate){ err in
                if err != nil {
                    //error actualizar fireabse
                    self.present(mostrarMsj(error: Constantes.DEFAULT), animated: true, completion: nil)
                }
                else {
                    Constantes.usuario.m_nombre = self.tfPrimerNombre.text!
                    Constantes.usuario.m_apellido = self.tfApellido.text!
                    Constantes.usuario.m_informacion = self.tvHistoria.text!
                    
                    if (Constantes.usuario.m_tipo == Constantes.USER_AGRICULTOR || Constantes.usuario.m_tipo == Constantes.USER_TENDERO || Constantes.usuario.m_tipo == Constantes.USER_RESTAURANTERO) {
                        Constantes.usuario.m_latitud = self.lat
                        Constantes.usuario.m_longitud = self.lon
                        Constantes.usuario.m_telefono = self.tfTelefono.text!
                    }
                    
                    self.delegado.actualizarPerfil(nombre: self.tfPrimerNombre.text!, apellido: self.tfApellido.text!, info: self.tvHistoria.text!, tlf: self.tfTelefono.text!)
                    
                    self.present(mostrarMsj(error: Constantes.EDITAR_OK, hand: {(action) -> Void in self.navigationController?.popViewController(animated: true)}),
                            animated: true, completion: nil)
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
