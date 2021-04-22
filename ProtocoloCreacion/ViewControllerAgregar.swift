//
//  ViewControllerAgregar.swift
//  ProtocoloCreacion
//
//  Created by user191001 on 4/7/21.
//

import UIKit

protocol protocoloAgregaPublicacion{
   
    func agregaPublicacion(pub : Publicacion)
}

class ViewControllerAgregar: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate	 {

    
    var delegado : protocoloAgregaPublicacion!
    
    @IBOutlet weak var fotoAgregar: UIImageView!
    
    @IBOutlet weak var textoPublicacion: UITextView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func agregarFoto(_ sender: UIButton) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    @IBAction func guardaPublicacion(_ sender: UIButton) {
        
        var publi = Publicacion(nombreUsuario: "Franco", fotoUsuario: fotoAgregar.image, texto: textoPublicacion.text)
        
        delegado.agregaPublicacion(pub: publi)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        let foto = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            
            fotoAgregar.image = foto
            
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
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
