//
//  BuscarViewController.swift
//  eating_sustainably-login
//
//  Created by user189360 on 5/15/21.
//

import UIKit
import iOSDropDown


class BuscarViewController: UIViewController, UITextFieldDelegate {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate: Bool {
        return false
    }
    
    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tfApellido: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfNeogcio: UITextField!
    @IBOutlet weak var ddTipo: DropDown!
    @IBOutlet weak var ddCategoria: DropDown!
    
    var tipo : Int = 0
    var categoria : Int = -1
    var tipoAnterior : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Buscar usuario"
        
        if (Constantes.auth.currentUser == nil){
            Constantes.usuario = Usuario()
        }
        
        ddTipo.inputView = UIView()
        ddCategoria.inputView = UIView()
        
        tfNombre.delegate = self
        tfApellido.delegate = self
        tfEmail.delegate = self
        tfNeogcio.delegate = self

        
        //variable auxiliar para las ids
        var optIds : [Int] = []
        ddTipo.optionArray.append("Ninguno")
        optIds.append(0)
        
        //bucle para tipo de usuarios que hay, el 0 es admin lo saltamos
        for i in 1 ..< Constantes.USER_TOTAL{
            ddTipo.optionArray.append(getUserStringName(users: i))
            optIds.append(i)
        }
        ddTipo.optionIds = optIds
        
        self.ddCategoria.isEnabled = false
        
        ddTipo.rowBackgroundColor = .lightGray
        ddTipo.selectedRowColor = .green
        
        ddCategoria.rowBackgroundColor = .lightGray
        ddCategoria.selectedRowColor = .green

        ddTipo.didSelect{(selectedText , index ,id) in
            self.tipo = id
            
            if (self.tipo != self.tipoAnterior) {
                self.ddCategoria.selectedIndex = nil
                self.categoria = -1
                self.ddCategoria.text = ""
            }
            self.tipoAnterior = self.tipo
            
            if (self.tipo == Constantes.USER_AGRICULTOR || self.tipo == Constantes.USER_TENDERO || self.tipo == Constantes.USER_RESTAURANTERO){
                //selecciona usuario vendedor, activamos categoria
                self.ddCategoria.isEnabled = true

                //variable para id de categoria
                var optIdsCat : [Int] = []
                
                //cargamos las diferentes categorias dependiendo del tipo de usuario
                self.ddCategoria.optionArray = definirCategorias(usuario:self.tipo)
                self.ddCategoria.optionArray.insert("Ninguno", at: 0)

                //bucle para las categorias
                for i in 0 ... self.ddCategoria.optionArray.count{
                    optIdsCat.append(i)
                }
                self.ddCategoria.optionIds = optIdsCat
            }
            else {
                self.ddCategoria.isEnabled = false
            }
        }
        
        ddCategoria.didSelect{(selectedText , index ,id) in
            self.categoria = id-1
        }
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
         return false
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "buscarUsuarios_resultado"{
            //si ha escrito un email comprobamos que el formato sea válido
            if (tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" && !isValidPattern(tfEmail.text ?? "", tipo: Constantes.MAIL)) {
                present(mostrarMsj(error: Constantes.MAIL), animated: true, completion: nil)
                return false
            }
            //si no ha seleccionado ningún criterio de búsqueda marcamos error
            if (tfNombre.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" && tfApellido.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" && tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" && tfNeogcio.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" && tipo == 0)
            {
                present(mostrarMsj(error: Constantes.BUSQUEDA), animated: true, completion: nil)
                return false
            }
        }
        return true
        
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "buscarUsuarios_resultado"{
            let viewResultados = segue.destination as! BuscarUsuariosResultadosTableViewController
            viewResultados.nombre = tfNombre.text!
            viewResultados.apellido = tfApellido.text!
            viewResultados.email = tfEmail.text!
            viewResultados.negocio = tfNeogcio.text!
            viewResultados.tipo = self.tipo
            viewResultados.categoria = self.categoria
        }
    }
}
