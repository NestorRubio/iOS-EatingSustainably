//
//  ListaValidarTableViewController.swift
//  eating_sustainably-login
//
//  Created by user189360 on 5/8/21.
//

import UIKit

class ListaValidarTableViewController: UITableViewController {
    
    var listaUsuarios : [String] = []
    var usuarioValidar : Usuario!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title="Usuarios pendientes de ser validados"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        Constantes.db.collection("usersNoValidados").getDocuments() { (querySnapshot, err) in
            if let document = querySnapshot, !document.isEmpty {
                for doc in document.documents {
                    self.listaUsuarios.append((doc.get("email")) as! String)
                }
                self.tableView.reloadData()
            }
            else {
                //self.present(mostrarMsj(error: Constantes.VALIDAR_VACIO), animated: true, completion: nil)
                self.present(mostrarMsj(error: Constantes.VALIDAR_VACIO, hand: {(action) -> Void in self.navigationController?.popViewController(animated: true)}),
                        animated: true, completion: nil)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listaUsuarios.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = listaUsuarios[indexPath.row]
        //subtitulo
        return cell
    }
    

    
    // MARK: - Navigation

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        //cargamos los datos
        let indice = tableView.indexPathForSelectedRow!
        let email = listaUsuarios[indice.row]

        Constantes.db.collection("users").whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
            if let document = querySnapshot, !document.isEmpty {
                //Cargamos los datos de usuario en el objeto
                for doc in document.documents {
                    self.usuarioValidar = Usuario(nombre: doc.get("nombre") as? String, apellido: doc.get("apellido") as? String, email: doc.get("email") as? String, tipo: doc.get("tipo") as? Int, uid: doc.documentID, latitud: doc.get("latitud") as? Double, longitud:doc.get("longitud") as? Double, foto: doc.get("foto") as? String, info: doc.get("informacion") as? String, video: doc.get("video") as? String, negocio: doc.get("negocio") as? String , proceso: doc.get("proceso") as? String, categorias: doc.get("categorias") as! [Int], tlf: doc.get("telefono") as? String)
                }
                
                //llamamos al segue cuando el usuario a validar se ha cargado
                self.performSegue(withIdentifier: "validar", sender: self)
            }
            else {
                self.present(mostrarMsj(error: Constantes.DEFAULT), animated: true, completion: nil)
            }
        }
        return false
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "validar"{
            let vistaValidar = segue.destination as! Registro1ViewController
            vistaValidar.validar = true
            vistaValidar.usuarioValidar = self.usuarioValidar
        }
    }
}
