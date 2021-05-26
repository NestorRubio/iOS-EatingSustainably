//
//  ViewControllerFAQ.swift
//  Pods
//
//  Created by user190188 on 5/16/21.
//

import UIKit

class ViewControllerFAQ: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    /*var FAQ = [FAQS(pregunta: "¿Cómo reestablezco mi contraseña?", respuesta: "En la página de inicio de sesión. Presionar el botón 'He olvidado mi contraseña' e introducir su correo. Recibirá un correo para reestablecer su contraseña"), FAQS(pregunta: "¿Cómo reviso la ubicación de un vendedor?", respuesta: "Al entrar al perfil del vendedor viene una mapa con la opcion de abrirlo y obtener direcciones"), FAQS(pregunta: "¿Cómo actualizo mi perfil de vendedor?", respuesta: "Si usted es un vendedor y quiere actualizar su perfil: Entre a la pestaña de perfil en la parte inferior derecha de la aplicacion y ahí puede editar."),FAQS(pregunta: "¿Cómo me pongo en contacto con el administrador?", respuesta: "Debe enviar un correo a la dirección: admin@gmail.com exponiendo su caso"),]
    */
    var FAQ : [FAQS] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tvFAQ: UITableView!
    var total = 0
    var seleccion = -1

    var hiddenSections = Set<Int>()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "FAQS"
        tvFAQ.delegate = self
        tvFAQ.dataSource = self
        
        Constantes.db.collection("faqs").getDocuments() { (querySnapshot, err) in
            if let document = querySnapshot, !document.isEmpty {
                self.total = document.documents.count
                for doc in document.documents {
                    self.FAQ.append(FAQS(pregunta: doc.get("pregunta") as! String, respuesta: doc.get("respuesta") as! String))
                    //cargamos cuando esten todos los datos
                    if (self.FAQ.count == self.total){
                        self.tableView.reloadData()
                    }
                }
            }
            else {
                //self.present(mostrarMsj(error: Constantes.BUSCAR_VACIO), animated: true, completion: nil)
                self.present(mostrarMsj(error: Constantes.DEFAULT, hand: {(action) -> Void in self.navigationController?.popViewController(animated:true)}),
                            animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FAQ.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaFAQ", for: indexPath)
        
        cell.textLabel?.text = FAQ[indexPath.row].pregunta
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        
        
        if (self.seleccion == indexPath.row){
            cell.detailTextLabel?.text = FAQ[indexPath.row].respuesta
            cell.detailTextLabel?.numberOfLines = 0
            cell.detailTextLabel?.font = UIFont.italicSystemFont(ofSize: 15)
        }
        else {
            cell.detailTextLabel?.text = ""
        }

        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.row == self.seleccion){
            self.seleccion = -1
        }
        else {
            self.seleccion = indexPath.row
        }
        tableView.reloadData()
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
