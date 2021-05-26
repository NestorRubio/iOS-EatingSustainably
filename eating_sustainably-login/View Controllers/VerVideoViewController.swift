//
//  VerVideoViewController.swift
//  eating_sustainably-login
//
//  Created by Enrique Elizondo on 5/26/21.
//

import UIKit
import youtube_ios_player_helper

class VerVideoViewController: UIViewController, YTPlayerViewDelegate {
    
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var lbNegocio: UILabel!
    @IBOutlet weak var lbDueno: UILabel!

    var usuarioVerPerfil : Usuario!
    var ver : Bool = false
    
    var idVideo : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.ver == true {
            lbDueno.text = usuarioVerPerfil.m_nombre!
            lbNegocio.text = usuarioVerPerfil.m_negocio!
            idVideo = usuarioVerPerfil.m_video!
        } else {
            lbDueno.text = Constantes.usuario.m_nombre
            lbNegocio.text = Constantes.usuario.m_negocio
            idVideo = Constantes.usuario.m_video!
        }
        playerView.delegate = self
        playerView.load(withVideoId: idVideo, playerVars: ["playsinline": 1])
        
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
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
