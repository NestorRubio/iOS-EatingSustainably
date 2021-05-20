//
//  ViewControllerFAQ.swift
//  Pods
//
//  Created by user190188 on 5/16/21.
//

import UIKit

class ViewControllerFAQ: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var FAQ = [FAQS(pregunta: "¿Como restablesco mi contraseña?", respuesta: "En la pagina de inicio de sesion. Presionar el boton de olvide mi contraseña e introducir su correo. Un correo para restablecer su contraseña"), FAQS(pregunta: "¿Como reviso la ubicacion de un vendedor?", respuesta: "Al entrar al perfil del vendedor viene una mapa con la opcion de abrirlo y obtener direcciones"), FAQS(pregunta: "¿Como actualizo mi perfil de vendedor?", respuesta: "Si usted es un vendedor y quiere actualizar su perfil. Entre a la pestaña de perfil en la parte inferior derecha de la aplicacion y ahi puede editar.")]
    
    
    @IBOutlet weak var tvFAQ: UITableView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "FAQS"
        tvFAQ.delegate = self
        tvFAQ.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FAQ.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaFAQ", for: indexPath)
        
        cell.textLabel?.text = FAQ[indexPath.row].pregunta
        
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
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
