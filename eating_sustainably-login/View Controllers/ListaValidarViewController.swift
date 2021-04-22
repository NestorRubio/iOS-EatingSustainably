//
//  ListaValidarViewController.swift
//  eating_sustainably-login
//
//  Created by user189360 on 4/22/21.
//

import UIKit

class ListaValidarViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var listaUsuarios : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        Constantes.db.collection("usersNoValidados").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.listaUsuarios.append((document.get("email")) as! String)
                    }
                }
        }
        
        tableView.reloadData()

        // Do any additional setup after loading the view.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return listaUsuarios.count
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            //siempre devuelve celda podemos quitar el opcional
    //EL IDENTIFIER TIENE QUE COINCIDIR CON EL QUE LE PONEMOS A LA CELDA EN LOS ATRIBUTOS ENN EL PASO 2
            let cell = tableView.dequeueReusableCell(withIdentifier: "celda")!
            //tituli
    //ETIQUETA PARA EL TITULO
            cell.textLabel?.text = listaUsuarios[indexPath.row]
            //subtitulo
            return cell
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
