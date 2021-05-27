//
//  VerVideoViewController.swift
//  eating_sustainably-login
//
//  Created by Enrique Elizondo on 5/26/21.
//

import UIKit
import youtube_ios_player_helper

class VerVideoViewController: UIViewController, YTPlayerViewDelegate, UIWebViewDelegate  {
    
    @IBOutlet weak var lbNegocio: UILabel!
    @IBOutlet weak var lbDueno: UILabel!

    var usuarioVerPerfil : Usuario!
    var ver : Bool = false
    
    @IBOutlet weak var video: WKWebView!
    
    var idVideo : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.ver == true {
            lbDueno.text = usuarioVerPerfil.m_nombre! + " " + usuarioVerPerfil.m_apellido!
            lbNegocio.text = usuarioVerPerfil.m_negocio!
            idVideo = usuarioVerPerfil.m_video!
        } else {
            lbDueno.text = Constantes.usuario.m_nombre! + " " + Constantes.usuario.m_apellido!
            lbNegocio.text = Constantes.usuario.m_negocio!
            idVideo = Constantes.usuario.m_video!
        }
        video.load(URLRequest(url: URL(string: idVideo!)!))
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
