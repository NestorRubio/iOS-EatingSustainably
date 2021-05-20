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
    var validar: Bool = false
    var usuarioValidar: Usuario!
    
    @IBOutlet weak var tfTelefono: UITextField!
    @IBOutlet weak var btnRegistrar: UIButton!
    @IBOutlet weak var lbValidar: UILabel!
    
    let locationManager = CLLocationManager()
    var latitud:Double?
    var longitud:Double?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnRegistrar.layer.cornerRadius = 8
        if (!validar){
            lbValidar.isHidden = true
            btnRegistrar.setTitle("Registrarse", for: .normal)

            // geolocalizacion si no estamos validando usuario
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
        else {
            
            tfTelefono.text = usuarioValidar.m_telefono
            tfTelefono.isEnabled = false
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.latitud = location.coordinate.latitude
            self.longitud = location.coordinate.longitude
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
        if (!validar){
            //si no tenemos permiso de localizacion no podemos continuar
            if (locationManager.authorizationStatus != .denied && locationManager.authorizationStatus != .restricted){
                //comprobamos que el telefono sea valido
                if (self.tfTelefono.text!.trimmingCharacters(in: .whitespacesAndNewlines) != "" && isValidPattern(self.tfTelefono.text!, tipo: Constantes.PHONE)) {
                    //creamos usuario firebase
                    Constantes.auth.createUser(withEmail: Constantes.usuario.m_email!, password: self.contraseña!) { result, error in
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
                           
                            
                            //el registro en firebase es correcto guardamos usuario en base de datos
                            Constantes.db.collection("users").document(result!.user.uid).setData(["nombre": Constantes.usuario.m_nombre!, "apellido":Constantes.usuario.m_apellido!, "email":Constantes.usuario.m_email!, "tipo":Constantes.usuario.m_tipo!, "informacion": Constantes.usuario.m_informacion!, "proceso":Constantes.usuario.m_proceso!, "negocio":Constantes.usuario.m_negocio!, "categorias":Constantes.usuario.m_categorias, "telefono": self.tfTelefono.text!, "latitud":self.latitud, "longitud":self.longitud, "foto":"", "video":""]) { err in
                                if let err = err {
                                    self.present(mostrarMsj(error: Constantes.DEFAULT), animated: true, completion: nil)
                                }
                                
                            }
                            
                            
                            //los guardamos como pendientes de ser validados
                            Constantes.db.collection("usersNoValidados").document(result!.user.uid).setData(["email":Constantes.usuario.m_email!]) { err in
                                if let err = err {
                                    self.present(mostrarMsj(error: Constantes.DEFAULT), animated: true, completion: nil)
                                }
                                //deslogeamos el usuario creado
                                do {
                                    try Constantes.auth.signOut()
                                }
                                catch let signOutError as NSError {
                                    self.present(mostrarMsj(error: Constantes.DEFAULT), animated: true, completion: nil)
                                }
                            }
                            


                            let portada = self.storyboard?.instantiateViewController(identifier: Constantes.Storyboard.portadaViewController) as? UINavigationController
                            
                            //mostramos mensajes de confirmacion y vamos a portada cuando el usuario acepta
                            self.present(mostrarMsj(error: Constantes.REGISTRO_OK, hand: {(action) -> Void in self.view.window?.rootViewController = portada
                                                        self.view.window?.makeKeyAndVisible()}), animated: true, completion: nil)
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
        //estamos validando
        else {
            Constantes.db.collection("usersNoValidados").document(usuarioValidar.m_uid!).delete(){ err in
                if let err = err {
                    self.present(mostrarMsj(error: Constantes.DEFAULT), animated: true, completion: nil)
                } else {
                    
                    //mostramos mensaje de confimacion y volvemos a portada
                    let home = self.storyboard?.instantiateViewController(identifier: Constantes.Storyboard.homeViewController) as? UITabBarController
                    
                    //mostramos mensajes de confirmacion y vamos a portada cuando el usuario acepta
                    self.present(mostrarMsj(error: Constantes.VALIDAR_OK, hand: {(action) -> Void in self.view.window?.rootViewController = home
                                                self.view.window?.makeKeyAndVisible()}), animated: true, completion: nil)                }
            }
        }
    }
}
