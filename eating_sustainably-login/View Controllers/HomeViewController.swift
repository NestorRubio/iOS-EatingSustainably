//
//  HomeViewController.swift
//  eating_sustainably-login
//
//  Created by user189360 on 4/21/21.
//

import UIKit

class HomeViewController: UIViewController {



    @IBOutlet weak var btnValidar: UIBarButtonItem!
    var tipoUsuario = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Feed general"

        // Do any additional setup after loading the view.
        
        if (tipoUsuario != 0)
        {
            btnValidar.isEnabled = true
            //btnValidar.isHidden = true
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
