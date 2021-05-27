//
//  BloquearViewController.swift
//  eating_sustainably-login
//
//  Created by user189360 on 5/15/21.
//

import UIKit
import FirebaseFirestore

protocol protocoloBloquear{
    func actualizarBloquear(estado : Bool)
}


class BloquearViewController: UIViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate: Bool {
        return false
    }
    
    @IBOutlet weak var bttnBloquear: UIButton!
    @IBOutlet weak var bttnDesbloquear: UIButton!
    
    var usuarioVerPerfil : Usuario!
    var ver : Bool = false
    var delegado : protocoloBloquear!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bloquear usuario"

        // Do any additional setup after loading the view.
        if usuarioVerPerfil.m_estado! == Constantes.CUENTA_ACTIVA{
            bttnDesbloquear.isHidden = true
            bttnDesbloquear.isEnabled = false
            bttnBloquear.isHidden = false
            bttnBloquear.isEnabled = true
        }else{
            bttnDesbloquear.isHidden = false
            bttnDesbloquear.isEnabled = true
            bttnBloquear.isHidden = true
            bttnBloquear.isEnabled = false
        }
    }
    
    func regresar(action : UIAlertAction){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func bloquear(_ sender: Any) {
        Constantes.db.collection("users").document(usuarioVerPerfil.m_uid!).updateData(["estado" : Constantes.CUENTA_BLOQUEADA]){ [self] err in
            if let err = err {
                //error actualizar fireabse
                self.present(mostrarMsj(error: Constantes.ERROR_BLOQUEAR), animated: true, completion: nil)
            }
            else {
                self.delegado.actualizarBloquear(estado: true)
                self.present(mostrarMsj(error: Constantes.BLOQUEAR_OK, hand: {(action) -> Void in self.navigationController?.popViewController(animated: true)}),
                        animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func desbloquear(_ sender: Any) {
        Constantes.db.collection("users").document(usuarioVerPerfil.m_uid!).updateData(["estado" : Constantes.CUENTA_ACTIVA]){ [self] err in
            if let err = err {
                //error actualizar fireabse
                self.present(mostrarMsj(error: Constantes.ERROR_DESBLOQUEAR), animated: true, completion: nil)
            }
            else {
                self.delegado.actualizarBloquear(estado: false)
                self.present(mostrarMsj(error: Constantes.DESBLOQUEAR_OK, hand: {(action) -> Void in self.navigationController?.popViewController(animated: true)}),
                        animated: true, completion: nil)
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
