//
//  Registro3ViewController.swift
//  eating_sustainably-login
//
//  Created by user189360 on 4/21/21.
//

import UIKit

class Registro3ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    

    var contraseña : String?
    var validar: Bool = false
    var usuarioValidar: Usuario!

    @IBOutlet weak var tvInfNegocio: UITextView!
    @IBOutlet weak var lbValidar: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnContinuar: UIButton!
    
    var categorias : [String] = []
    var categoriasSeleccionadas : [Int] = []
    var placeholder = "Define el proceso sustentable de tu negocio"


    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Información del negocio"
        // Do any additional setup after loading the view.
        tableView.allowsMultipleSelection = true
        
        tvInfNegocio.delegate = self
        self.tvInfNegocio.layer.borderColor = UIColor.lightGray.cgColor
        tvInfNegocio.layer.borderWidth = 1.0
        btnContinuar.layer.cornerRadius = 8

        tvInfNegocio.text = placeholder
        tvInfNegocio.textColor = UIColor.lightGray
                
        categorias = definirCategorias(usuario:Constantes.usuario.m_tipo!)
        
        if (!validar){
            lbValidar.isHidden = true
        }
        else {
            tvInfNegocio.text = usuarioValidar.m_proceso
            tvInfNegocio.isEditable = false
            
            //definimos el nombre de las categorias del usuario
            categorias = definirCategorias(usuario: usuarioValidar.m_tipo!)
            
            //ponemos las categorias seleccionadas
            categoriasSeleccionadas = usuarioValidar.m_categorias
            
            //no permitimos seleccionar en el table view
            tableView.allowsSelection = false
            
            //mostramos la tabla
            tableView.reloadData()
        }

    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if tvInfNegocio.textColor == UIColor.lightGray {
            tvInfNegocio.text = nil
            tvInfNegocio.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if tvInfNegocio.text.isEmpty {
            tvInfNegocio.text = placeholder
            tvInfNegocio.textColor = UIColor.lightGray
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return categorias.count
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            //siempre devuelve celda podemos quitar el opcional
    //EL IDENTIFIER TIENE QUE COINCIDIR CON EL QUE LE PONEMOS A LA CELDA EN LOS ATRIBUTOS ENN EL PASO 2
            let cell = tableView.dequeueReusableCell(withIdentifier: "celda")!
            //tituli
    //ETIQUETA PARA EL TITULO
            cell.textLabel?.text = categorias[indexPath.row]
        
        if categoriasSeleccionadas.contains(indexPath.row){
            cell.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        }
        else{
            cell.backgroundColor = UIColor.white
        }

            return cell
       }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !categoriasSeleccionadas.contains(indexPath.row) {
            categoriasSeleccionadas.append(indexPath.row)
        }
        else {
            categoriasSeleccionadas = categoriasSeleccionadas.filter {$0 != indexPath.row}
        }
        tableView.reloadData()
    }


    
    // MARK: - Navigation

    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        var ejecutarSegue = true
        if (!validar){
            if (tvInfNegocio.text == placeholder){
                tvInfNegocio.text = ""
            }
            if (tvInfNegocio.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
                
                self.present(mostrarMsj(error: Constantes.PROCESO), animated: true, completion: nil)
                ejecutarSegue = false
            }
            if (self.categoriasSeleccionadas.isEmpty)
            {
                self.present(mostrarMsj(error: Constantes.CATEGORIA), animated: true, completion: nil)
                ejecutarSegue = false
            }
        }

        return ejecutarSegue
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "registro3_4"{
            
            Constantes.usuario.m_proceso = tvInfNegocio.text!
            Constantes.usuario.m_categorias = self.categoriasSeleccionadas
            
            let viewR4 = segue.destination as! Registro4ViewController
            viewR4.contraseña = self.contraseña
            viewR4.validar = self.validar
            viewR4.usuarioValidar = self.usuarioValidar
        }
    }
}
