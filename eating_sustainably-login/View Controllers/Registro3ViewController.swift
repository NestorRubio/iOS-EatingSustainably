//
//  Registro3ViewController.swift
//  eating_sustainably-login
//
//  Created by user189360 on 4/21/21.
//

import UIKit

class Registro3ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    var nombre : String?
    var apellido : String?
    var email  : String?
    var contraseña : String?
    var tipoUsuario : Int?
    var nombreNegocio: String?
    var informacion: String?
    
    

    @IBOutlet weak var tvInfNegocio: UITextView!
    
    @IBOutlet weak var lbError: UILabel!
    
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
        
        lbError.text = ""
        
        categorias = definirCategorias(usuario:self.tipoUsuario!)
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
            //subtitulo
            return cell
       }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            if !categoriasSeleccionadas.contains(indexPath.row) {
                categoriasSeleccionadas.append(indexPath.row)
            }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if categoriasSeleccionadas.contains(indexPath.row) {
            categoriasSeleccionadas = categoriasSeleccionadas.filter {$0 != indexPath.row}
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        var ejecutarSegue = true
        if (tvInfNegocio.text == placeholder){
            tvInfNegocio.text = ""
        }
        if (tvInfNegocio.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            lbError.text = "Introduce el proceso sustentable del negocio"
            ejecutarSegue = false
        }
        if (self.categoriasSeleccionadas.isEmpty)
        {
            lbError.text = "Selecciona al menos una categoría"
            ejecutarSegue = false
        }
        return ejecutarSegue

    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "registro3_4"{
            let viewR4 = segue.destination as! Registro4ViewController
            viewR4.nombre = self.nombre
            viewR4.apellido = self.apellido
            viewR4.email = self.email
            viewR4.contraseña = self.contraseña
            viewR4.tipoUsuario = self.tipoUsuario
            viewR4.nombreNegocio = self.nombreNegocio
            viewR4.informacion = self.informacion
            viewR4.sustentable = tvInfNegocio.text!
            viewR4.categorias = self.categoriasSeleccionadas

            lbError.text = ""
        }
        
    }

}
