//
//  LogInViewController.swift
//  eating_sustainably-login
//
//  Created by user190188 on 4/21/21.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {
    
    
    @IBOutlet weak var tfEmail: UITextField!
    
    
    @IBOutlet weak var tfPassword: UITextField!
    
    
    @IBOutlet weak var bttnInicioSesion: UIButton!
    
    
    @IBOutlet weak var lbError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        lbError.alpha = 0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func loginTap(_ sender: Any) {
        //validate textfields
        let email = tfEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = tfPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //signin in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil{
                self.lbError.text = error!.localizedDescription
                self.lbError.alpha = 1
            }else{
                
                let homeViewController = self.storyboard?.instantiateViewController(identifier: Constantes.Storyboard.homeViewController) as? HomeViewController
                
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
    
}
