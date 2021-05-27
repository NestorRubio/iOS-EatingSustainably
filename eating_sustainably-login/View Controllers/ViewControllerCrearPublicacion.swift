//
//  ViewControllerCrearPublicacion.swift
//  eating_sustainably-login
//
//  Created by user190188 on 5/24/21.
//

import UIKit
import FirebaseFirestore

class ViewControllerCrearPublicacion: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var tfPost: UITextView!
    
    @IBOutlet weak var bttnPublicar: UIButton!
    
    @IBOutlet weak var fotoPublicacion: UIImageView?
    
    @IBOutlet weak var btnAgregarFoto: UIButton!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func publicar(_ sender: UIButton) {
        let date = Date();
        let format = DateFormatter();
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestamp = format.string(from: date)
        
        let referencia = Constantes.db.collection("posts").document()
        
        if let foto = fotoPublicacion?.image{
            
            let data = foto.pngData()
            
            Constantes.storage.child("fotosPublicaciones/" + referencia.documentID + ".png").putData(data!, metadata: nil, completion: {_,error in
                if error == nil {
                    referencia.setData(["likes": 0, "name": Constantes.usuario.m_nombre! + " " + Constantes.usuario.m_apellido! , "post": self.tfPost.text!,"timestamp": timestamp, "foto": "fotosPublicaciones/" + referencia.documentID + ".png", "uid": Constantes.usuario.m_uid]){
                        [self] err in
                        if let err = err{
                            self.present(mostrarMsj(error: Constantes.ERROR_FOTO_FB), animated: true, completion: nil)
                            
                            //agregar a la vista anterior usando protocolo
                        }
                        
                    }
                }
                
            })
            
            
        }
        else{
            referencia.setData(["likes": 0, "name": Constantes.usuario.m_nombre! + " " + Constantes.usuario.m_apellido! , "post": self.tfPost.text!,"timestamp": timestamp, "foto": "nil", "uid": Constantes.usuario.m_uid])
        }
                
        //db.collection("posts").addDocument(data: ["likes": 0, "name": Constantes.usuario.m_nombre! + " " + Constantes.usuario.m_apellido! , "post": tfPost.text!,"timestamp": timestamp])

        
        //mensaje de confirmación y vuelta al feed general
        self.present(mostrarMsj(error: Constantes.PUBLICACION_OK, hand: {(action) -> Void in self.navigationController?.popViewController(animated: true)}),
                animated: true, completion: nil)
        
    }

    
    @IBAction func agregarFoto(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    
    //MARK: - Métodos de delgado UIImage Picker Controller
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.fotoPublicacion?.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
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
