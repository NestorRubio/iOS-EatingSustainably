//
//  CodigoQRViewController.swift
//  eating_sustainably-login
//
//  Created by user189360 on 5/14/21.
//

import UIKit

class CodigoQRViewController: UIViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate: Bool {
        return false
    }
    
    @IBOutlet weak var imgQR: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Código QR"

        // Do any additional setup after loading the view.
        
        if let filtro = CIFilter(name: "CIQRCodeGenerator") {
            filtro.setValue(Constantes.usuario.m_uid!.data(using: String.Encoding.utf8), forKey: "inputMessage")
            
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let codigo = filtro.outputImage?.transformed(by: transform) {
                imgQR.image = UIImage(ciImage: codigo)
            }
            else {
                let perfil = self.storyboard?.instantiateViewController(identifier: Constantes.Storyboard.perfilViewController) as? UINavigationController
                //mostramos mensajes de confirmacion y vamos a portada cuando el usuario acepta
                self.present(mostrarMsj(error: Constantes.QR_GENERAR, hand: {(action) -> Void in self.view.window?.rootViewController = perfil
                                            self.view.window?.makeKeyAndVisible()}), animated: true, completion: nil)
            }
        }
        else{
            let perfil = self.storyboard?.instantiateViewController(identifier: Constantes.Storyboard.perfilViewController) as? UINavigationController
            //mostramos mensajes de confirmacion y vamos a portada cuando el usuario acepta
            self.present(mostrarMsj(error: Constantes.QR_GENERAR, hand: {(action) -> Void in self.view.window?.rootViewController = perfil
                                        self.view.window?.makeKeyAndVisible()}), animated: true, completion: nil)
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
