//
//  RecuperarViewController.swift
//  eating_sustainably-login
//
//  Created by user189360 on 5/12/21.
//

import UIKit
import FirebaseAuth

class RecuperarViewController: UIViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate: Bool {
        return false
    }

    @IBOutlet weak var tfEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recuperar contraseña"

        // Do any additional setup after loading the view.
    }
    

    @IBAction func recuperar(_ sender: UIButton) {
        
        //comprobar email
        if (tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" || isValidPattern(tfEmail.text ?? "", tipo: Constantes.MAIL)) {
            
            Constantes.auth.sendPasswordReset(withEmail: tfEmail.text!) { error in
                //error al enviar el email
                if error != nil, let error = error as NSError?{
                    if let errorCode = AuthErrorCode(rawValue: error.code) {
                        switch errorCode {
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
                //se ha enviado el email de recuperacion
                else {
                    //mostramos mensajes de confirmacion y volvemos a la vista anterior
                    self.present(mostrarMsj(error: Constantes.RECUPERAR, hand: {(action) -> Void in self.navigationController?.popViewController(animated: true)}),
                            animated: true, completion: nil)
                }
            }
        }
        //formato de email incorrecto
        else {
            present(mostrarMsj(error: Constantes.MAIL), animated: true, completion: nil)
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
