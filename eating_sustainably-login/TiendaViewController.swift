//
//  TiendaViewController.swift
//  eating_sustainably-login
//
//  Created by user189360 on 5/21/21.
//

import UIKit

class TiendaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var usuarioVerPerfil : Usuario!
    var ver : Bool = false

    @IBOutlet weak var tableView: UITableView!
    
    var listaProductos : [Producto] = []
    var total = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Constantes.usuario.m_negocio!
        
        Constantes.db.collection("productos").whereField("uid", isEqualTo: Constantes.usuario.m_uid!).getDocuments() { (querySnapshot, err) in
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
                                self.listaProductos.append(Producto(nombre: doc.get("nombre") as! String, categoria: doc.get("nombre") as! String, descripcion: doc.get("descripcion") as! String, precio: doc.get("precio") as! Double, imagen: UIImage(named: "avatarPerfil")!, uidProducto: doc.documentID, uidVendedor: doc.get("uid") as! String))
                            }
                        }
                        //cargamos cuando esten todos los datos
                        if (self.listaProductos.count == self.total){
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            else {
                self.present(mostrarMsj(error: Constantes.TIENDA_VACIA), animated: true, completion: nil)
            }
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
        cell.lbPrecio.text = String(listaProductos[indexPath.row].m_precio) + "$ c/u"
        cell.imgProducto.image = listaProductos[indexPath.row].m_imagen

        return cell
   }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "tienda_agregar"{
            let vistaAgregar = segue.destination as! AgregarProductoViewController

        }
        
    }
    

}
