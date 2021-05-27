//
//  BloquearViewController.swift
//  eating_sustainably-login
//
//  Created by user189360 on 5/15/21.
//

import UIKit
import FirebaseFirestore


class BloquearViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var bttnBloquear: UIButton!
    @IBOutlet weak var bttnDesbloquear: UIButton!
    
    var usuarioVerPerfil : Usuario!
    var ver : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bloquear usuario"

        // Do any additional setup after loading the view.
        if usuarioVerPerfil.m_estado == 0{
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
        usuarioVerPerfil.m_estado = 2
        db.collection("users").document(usuarioVerPerfil.m_uid!).setData(["estado" : 2], merge: true)
        let alertController = UIAlertController(title: "Aviso", message: "Se ha bloqueado al usuario", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Entendido", style: .default, handler: regresar))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func desbloquear(_ sender: Any) {
        usuarioVerPerfil.m_estado = 0
        db.collection("users").document(usuarioVerPerfil.m_uid!).setData(["estado" : 0], merge: true)
        let alertController = UIAlertController(title: "Aviso", message: "Se ha desbloqueado al usuario", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Entendido", style: .default, handler: regresar))
        self.present(alertController, animated: true, completion: nil)
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
