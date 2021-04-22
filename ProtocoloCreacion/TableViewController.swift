//
//  TableViewController.swift
//  ProtocoloCreacion
//
//  Created by user191001 on 4/7/21.
//

import UIKit

class TableViewController: UITableViewController, protocoloAgregaPublicacion {
    
    

    var listaPublicaciones = [
        Publicacion(nombreUsuario: "Franco", fotoUsuario: UIImage(named:"beto")!,texto: "Excelente producto totalmente organico, estamos teniendo la mejor cosecha del anio. Excelente producto totalmente organico, estamos teniendo la mejor cosecha del anio. Excelente producto totalmente organico, estamos teniendo la mejor cosecha del anio. Excelente producto totalmente organico, estamos teniendo la mejor cosecha del anio. Excelente producto totalmente organico, estamos teniendo la mejor cosecha del anio. Excelente producto totalmente organico, estamos teniendo la mejor cosecha del anio. Excelente producto totalmente organico, estamos teniendo la mejor cosecha del anio."),
        Publicacion(nombreUsuario: "Maria", fotoUsuario: UIImage(named:"persona")!, texto: "Compren sus calabazas.", fotoPublicacion: UIImage(named:"enrique")!)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBAction func unwindCancelar(segue: UIStoryboardSegue){
        
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listaPublicaciones.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "publicacionSoloTexto", for: indexPath) as! TableViewCell
        
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "publicacionConFoto", for: indexPath) as! TableViewCellFoto

        // Configure the cell...
        
        if let foto = listaPublicaciones[indexPath.row].fotoPublicacion{
            
            cell2.nombreUsuario.text = listaPublicaciones[indexPath.row].nombreUsuario
            
            cell2.fotoUsuario.image = listaPublicaciones[indexPath.row].fotoUsuario
            
            cell2.textoPublicacion.text = listaPublicaciones[indexPath.row].texto
            
            cell2.fotoPublicacion.image = foto
            
            return cell2
            
        }
        else{
            cell.fotoUsuario.image = UIImage(named: "user")
            
            cell.nombreUsuario.text = listaPublicaciones[indexPath.row].nombreUsuario
            
            cell.textoPublicacion.text = listaPublicaciones[indexPath.row].texto
            
            return cell
        }
        
    }
    
    /*override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 142
    }*/
    
    func agregaPublicacion(pub: Publicacion) {
        listaPublicaciones.append(pub)
        tableView.reloadData()
    }
    	
    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
        //segue.identifier == "agregar"
            
            let vistaDetallee = segue.destination as! ViewControllerAgregar
            vistaDetallee.delegado = self
            
        
        
        
        
    }
    

}
