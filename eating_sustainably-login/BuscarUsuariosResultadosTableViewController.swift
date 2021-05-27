//
//  BuscarUsuariosResultadosTableViewController.swift
//  eating_sustainably-login
//
//  Created by user189360 on 5/20/21.
//

import UIKit
import FirebaseFirestore
import FirebaseUI

class BuscarUsuariosResultadosTableViewController: UITableViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate: Bool {
        return false
    }

    var nombre : String!
    var apellido : String!
    var email : String!
    var negocio : String!
    var tipo : Int!
    var categoria : Int!
    
    var listaUsuarios : [(String, String, UIImage, String)] = []
    var usuarioVerPerfil : Usuario!
    var total = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        var query : Query = Constantes.db.collection("users")
        

        if (negocio != ""){
            query = query.whereField("negocio_query", isEqualTo: negocio!.lowercased())
        }
        if (nombre != ""){
            query = query.whereField("nombre_query", isEqualTo: nombre!.lowercased())
        }
        if (apellido != ""){
            query = query.whereField("apellido_query", isEqualTo: apellido!.lowercased())
        }
        if (email != ""){
            query = query.whereField("email_query", isEqualTo: email!.lowercased())
        }
        if (tipo != 0){
            query = query.whereField("tipo", isEqualTo: tipo!)
        }
        if (categoria != -1){
            query = query.whereField("categorias", arrayContains: categoria!)
        }
        
        query.getDocuments() { (querySnapshot, err) in
            if let document = querySnapshot, !document.isEmpty {
                self.total = document.documents.count
                for doc in document.documents {
                    Constantes.storage.child(doc.get("foto") as! String).getData(maxSize: 1 * 1024 * 1024) { data, error in
                        if let error = error {
                            self.present(mostrarMsj(error: Constantes.DEFAULT), animated: true, completion: nil)
                        }
                        else {
                            //mostramos resultados si la cuenta esta activa o es un admin que puede ver todos
                            if (doc.get("estado") as! Int == Constantes.CUENTA_ACTIVA || (Constantes.usuario.m_tipo == Constantes.USER_ADMIN && doc.get("estado") as! Int == Constantes.CUENTA_BLOQUEADA)){
                                //si hemos recibido imagen la cargamos
                                if let foto = UIImage(data: data!){
                                    self.listaUsuarios.append((doc.get("nombre") as! String, getUserStringName(users: (doc.get("tipo")) as! Int), foto, doc.documentID))
                                }
                                //sino usamos placeholder
                                else {
                                    self.listaUsuarios.append((doc.get("nombre") as! String, getUserStringName(users: (doc.get("tipo")) as! Int), UIImage(named: "avatarPerfil")!, doc.documentID))
                                }
                            }
                            else {
                                self.total-=1
                            }
                            
                        }
                        //cargamos cuando esten todos los datos
                        if (self.listaUsuarios.count == self.total){
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            else {
                //self.present(mostrarMsj(error: Constantes.BUSCAR_VACIO), animated: true, completion: nil)
                self.present(mostrarMsj(error: Constantes.BUSCAR_VACIO, hand: {(action) -> Void in self.navigationController?.popViewController(animated:true)}),
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
        cell.textLabel?.text = listaUsuarios[indexPath.row].0
        //subtitulo
        cell.detailTextLabel?.text = listaUsuarios[indexPath.row].1
        //foto
        cell.imageView?.image = listaUsuarios[indexPath.row].2
        
        return cell
    }
    // MARK: - Navigation

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
            if (identifier == "buscar_perfil"){
            //cargamos los datos
            let indice = tableView.indexPathForSelectedRow!
            let uid = listaUsuarios[indice.row].3
            
            Constantes.db.collection("users").document(uid).getDocument { (documentSnapshot, error) in
                if let doc = documentSnapshot, doc.exists {
                    self.usuarioVerPerfil = Usuario(nombre: doc.get("nombre") as? String, apellido: doc.get("apellido") as? String, email: doc.get("email") as? String, tipo: doc.get("tipo") as? Int, uid: doc.documentID, foto: doc.get("foto") as? String, info: doc.get("informacion") as? String, estado: doc.get("estado") as? Int)
                    
                    //si es tipo vendedor cargamos datos adicionales
                    if (doc.get("tipo") as? Int == Constantes.USER_TENDERO || doc.get("tipo") as? Int == Constantes.USER_AGRICULTOR || doc.get("tipo") as? Int == Constantes.USER_RESTAURANTERO){
                        self.usuarioVerPerfil.m_latitud = doc.get("latitud") as? Double
                        self.usuarioVerPerfil.m_longitud = doc.get("longitud") as? Double
                        self.usuarioVerPerfil.m_negocio = doc.get("negocio") as? String
                        self.usuarioVerPerfil.m_proceso = doc.get("proceso") as? String
                        self.usuarioVerPerfil.m_categorias = doc.get("categorias") as! [Int]
                        self.usuarioVerPerfil.m_video = doc.get("video") as? String
                        self.usuarioVerPerfil.m_telefono = doc.get("telefono") as? String
                    }
                    
                    if (self.usuarioVerPerfil.m_foto! != ""){
                        Constantes.storage.child(self.usuarioVerPerfil.m_foto!).getData(maxSize: 1 * 1024 * 1024) { data, error in
                            if let error = error {
                                self.usuarioVerPerfil.m_foto = ""
                            }
                            else {
                                self.usuarioVerPerfil.m_imagen = UIImage(data: data!)
                                //llamamos al segue cuando el usuariose ha cargado
                                self.performSegue(withIdentifier: "buscar_perfil", sender: self)
                            }
                        }
                    }
                    else{
                        //llamamos al segue cuando el usuario se ha cargado
                        self.performSegue(withIdentifier: "buscar_perfil", sender: self)
                    }
                }
                else {
                    self.present(mostrarMsj(error: Constantes.DEFAULT), animated: true, completion: nil)
                }
            }
        }
        
        return false
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "buscar_perfil"{
            let vistaPerfil = segue.destination as! PerfilViewController
            vistaPerfil.ver = true
            vistaPerfil.usuarioVerPerfil = self.usuarioVerPerfil
        }
    }

    
    

}

