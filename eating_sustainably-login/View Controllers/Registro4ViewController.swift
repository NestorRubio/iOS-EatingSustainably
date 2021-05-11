//
//  Registro4ViewController.swift
//  eating_sustainably-login
//
//  Created by user189360 on 4/21/21.
//

import UIKit
import FirebaseAuth
import CoreLocation


class Registro4ViewController: UIViewController, CLLocationManagerDelegate {
    

    var contraseña : String?
    var nombreNegocio: String?
    var informacion: String?
    var sustentable: String?
    var categorias: [Int]?
    let locationManager = CLLocationManager()
    var latitud:Double?
    var longitud:Double?

    @IBOutlet weak var tfTelefono: UITextField!
    @IBOutlet weak var btnRegistrar: UIButton!
    @IBOutlet weak var lbValidar: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnRegistrar.layer.cornerRadius = 8
        

        // Handle each case of location permissions
        switch locationManager.authorizationStatus {
        
            case .authorizedAlways, .authorizedWhenInUse:
                //tenemos permisos podemos acceder a la localizacion
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.requestLocation()
                break
                
            case .denied:
                //mostramos error de permisis
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
        }
        
        
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.latitud = location.coordinate.latitude
            self.longitud = location.coordinate.longitude
            
            //lbValidar.text = String(self.latitud!) + " " + String(self.longitud!)
        }

    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        // Handle failure to get a user’s location
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func registrarUsuario(_ sender: UIButton) {
        //si no tenemos permiso de localizacion no podemos continuar
        if (locationManager.authorizationStatus != .denied && locationManager.authorizationStatus != .restricted){
            //comprobamos que el telefono sea valido
            if (self.tfTelefono.text!.trimmingCharacters(in: .whitespacesAndNewlines) != "" && isValidPattern(self.tfTelefono.text!, tipo: Constantes.PHONE)) {
                //creamos usuario firebase
                Auth.auth().createUser(withEmail: Constantes.usuario.m_email!, password: self.contraseña!) { result, error in
                    if error != nil, let error = error as NSError?{
                        if let errorCode = AuthErrorCode(rawValue: error.code) {
                            switch errorCode {
                            case .invalidEmail:
                                self.present(mostrarMsj(error: Constantes.FIREBASE_MAIL), animated: true, completion: nil)
                                break
                            case .emailAlreadyInUse:
                                self.present(mostrarMsj(error: Constantes.FIREBASE_MAIL_REPETIDO), animated: true, completion: nil)
                                break
                            case .weakPassword:
                                self.present(mostrarMsj(error: Constantes.FIREBASE_PASSWORD), animated: true, completion: nil)
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
                    else {
                        //guardamos id
                        Constantes.usuario.m_uid = result!.user.uid
                        
                        //el registro en firebase es correcto guardamos usuario en base de datos
                        Constantes.db.collection("usersNoValidados").document(result!.user.uid).setData(["nombre": Constantes.usuario.m_nombre!, "apellido":Constantes.usuario.m_apellido!, "email":Constantes.usuario.m_email!, "tipoUsuario":Constantes.usuario.m_tipo!, "informacion": self.informacion!, "sustentable":self.sustentable!, "negocio":self.nombreNegocio!, "categorias":self.categorias!, "telefono": self.tfTelefono.text!])
                        
                        let homeViewController = self.storyboard?.instantiateViewController(identifier: Constantes.Storyboard.homeViewController) as? HomeViewController
                        self.view.window?.rootViewController = homeViewController
                        self.view.window?.makeKeyAndVisible()
                    }
                }
            }
            else{
                self.present(mostrarMsj(error: Constantes.PHONE), animated: true, completion: nil)
            }
        }
        else{
            self.present(mostrarMsj(error: Constantes.PERMISOS_LOC), animated: true, completion: nil)
        }
    }
}
