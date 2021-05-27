//
//  TiendaViewController.swift
//  eating_sustainably-login
//
//  Created by user189360 on 5/21/21.
//

import UIKit

class TiendaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, protocoloAgregar {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate: Bool {
        return false
    }
    
    var usuarioVerPerfil : Usuario!
    var ver : Bool = false

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnEliminar: UIBarButtonItem!
    @IBOutlet weak var btnAgregar: UIButton!
    
    var eliminar = false
    
    var listaProductos : [Producto] = []
    var total = 0
    var id_usuario : String!
    var unidadPrecio : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.allowsSelection = false

        //caso viendo perfil de otro usuario
        if (ver == true){
            //si es el admin puede eliinar productos
            if (Constantes.usuario.m_tipo == Constantes.USER_ADMIN){
                navigationItem.rightBarButtonItems = [btnEliminar]
            }
            else {
                navigationItem.rightBarButtonItems = []
            }
            btnAgregar.isHidden = true
            title = usuarioVerPerfil.m_negocio!
            id_usuario = usuarioVerPerfil.m_uid
            if (usuarioVerPerfil.m_tipo == Constantes.USER_RESTAURANTERO){
                self.unidadPrecio = "$ c/ración"
            }
            else{
                self.unidadPrecio = "$ Kg"
            }
        }
        //caso usuario que mira su tienda
        else {
            title = Constantes.usuario.m_negocio!
            navigationItem.rightBarButtonItems = [btnEliminar]
            btnAgregar.isHidden = false
            id_usuario = Constantes.usuario.m_uid!
            if (Constantes.usuario.m_tipo == Constantes.USER_RESTAURANTERO){
                self.unidadPrecio = "$ c/ración"
            }
            else{
                self.unidadPrecio = "$ Kg"
            }
        }

        Constantes.db.collection("productos").whereField("uid", isEqualTo: id_usuario!).getDocuments() { (querySnapshot, err) in
            if let document = querySnapshot, !document.isEmpty {
                self.total = document.documents.count
                for doc in document.documents {
                    Constantes.storage.child(doc.get("foto") as! String).getData(maxSize: 1 * 1024 * 1024) { data, error in
                        if let error = error {
                            self.present(mostrarMsj(error: Constantes.ERROR_FOTO_ST), animated: true, completion: nil)
                        }
                        else {
                            //si hemos recibido imagen la cargamos
                            if let foto = UIImage(data: data!){
                                self.listaProductos.append(Producto(nombre: doc.get("nombre") as! String, categoria: doc.get("categoria") as! String, descripcion: doc.get("descripcion") as! String, precio: doc.get("precio") as! Double, imagen: foto, uidProducto: doc.documentID, uidVendedor: doc.get("uid") as! String))
                                                           
                            }
                            //sino usamos placeholder
                            else {
                                self.listaProductos.append(Producto(nombre: doc.get("nombre") as! String, categoria: doc.get("nombre") as! String, descripcion: doc.get("descripcion") as! String, precio: doc.get("precio") as! Double, imagen: UIImage(named: "fotoNoDisponible")!, uidProducto: doc.documentID, uidVendedor: doc.get("uid") as! String))
                            }
                        }
                        //cargamos cuando esten todos los datos
                        //if (self.listaProductos.count == self.total){
                            self.tableView.reloadData()
                        //}
                    }
                }
            }
            else {
                self.present(mostrarMsj(error: Constantes.TIENDA_VACIA), animated: true, completion: nil)
            }
        }
    }
    func agregarProducto(producto : Producto){
        listaProductos.append(producto)
        tableView.reloadData()
    }
    
    @IBAction func eliminarProducto(_ sender: UIBarButtonItem) {
        if (eliminar == false){
            eliminar = true
            self.tableView.setEditing(true, animated: true)
            self.navigationItem.rightBarButtonItem?.image = nil
            self.navigationItem.rightBarButtonItem?.title = "OK"

        }
        else {
            eliminar = false
            self.tableView.setEditing(false, animated: true)
            self.navigationItem.rightBarButtonItem?.title = ""
            self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "trash")
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaProductos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! TiendaTableViewCell
        
        cell.lbNombre.text = listaProductos[indexPath.row].m_nombre
        cell.lbDescripcion.text = listaProductos[indexPath.row].m_descripcion
        cell.lbCategoria.text = listaProductos[indexPath.row].m_categoria
        cell.lbPrecio.text = String(listaProductos[indexPath.row].m_precio) + self.unidadPrecio
        cell.imgProducto.image = listaProductos[indexPath.row].m_imagen

        return cell
   }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if (ver == false || Constantes.usuario.m_tipo == Constantes.USER_ADMIN) {
            return true
        }
        else {
            return false
        }
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            Constantes.db.collection("productos").document(listaProductos[indexPath.row].m_uidProducto).delete() { err in
                if let err = err {
                    self.present(mostrarMsj(error: Constantes.DEFAULT), animated: true, completion: nil)
                } else {
                    self.listaProductos.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "tienda_agregar"{
            let vistaAgregar = segue.destination as! AgregarProductoViewController
            vistaAgregar.delegado = self
            self.tableView.setEditing(false, animated: true)
            self.navigationItem.rightBarButtonItem?.title = ""
            self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "trash")
        }
    }
}
