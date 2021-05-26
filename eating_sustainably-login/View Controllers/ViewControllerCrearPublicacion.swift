//
//  ViewControllerCrearPublicacion.swift
//  eating_sustainably-login
//
//  Created by user190188 on 5/24/21.
//

import UIKit
import FirebaseFirestore

class ViewControllerCrearPublicacion: UIViewController {
    
    @IBOutlet weak var tfPost: UITextView!
    
    @IBOutlet weak var bttnPublicar: UIButton!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func publicar(_ sender: UIButton) {
        
        db.collection("posts").addDocument(data: ["likes": 0, "name": Constantes.usuario.m_nombre! + " " + Constantes.usuario.m_apellido! , "post": tfPost.text!])
        
        //mensaje de confirmación y vuelta al feed general
        self.present(mostrarMsj(error: Constantes.PUBLICACION_OK, hand: {(action) -> Void in self.navigationController?.popViewController(animated: true)}),
                animated: true, completion: nil)
        
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
