//
//  AgregarProductoViewController.swift
//  eating_sustainably-login
//
//  Created by user189360 on 5/21/21.
//

import UIKit
import iOSDropDown

protocol protocoloAgregar{
    func agregarProducto(producto : Producto)
}

class AgregarProductoViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate: Bool {
        return false
    }

    @IBOutlet weak var tvDescripcion: UITextView!
    @IBOutlet weak var ddCategoria: DropDown!
    @IBOutlet weak var tfPrecio: UITextField!
    @IBOutlet weak var tfNombre: UITextField!

    @IBOutlet weak var imgFoto: UIImageView!
    
    var delegado : protocoloAgregar!

    
    var placeholder = "Escribe la descripción del producto"

    var foto : UIImage!
    var categoria : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Añadir producto"


        tfNombre.delegate = self
        tfPrecio.delegate = self
        ddCategoria.inputView = UIView()

        
        //placeholder para el textview, se debe programar
        tvDescripcion.delegate = self
        tvDescripcion.layer.borderColor = UIColor.lightGray.cgColor
        tvDescripcion.layer.borderWidth = 1.0
        tvDescripcion.text = placeholder
        tvDescripcion.textColor = UIColor.lightGray
        
        imgFoto.contentMode = .scaleAspectFit
        
        //dropdown de posibles categorias dependiendo del usuario
        var optIdsCat : [Int] = []
        
        //cargamos las diferentes categorias dependiendo del tipo de usuario
        var categoriasTipo = definirCategorias(usuario: Constantes.usuario.m_tipo!)
        var categoriasContador = 0
        
        //bucle para las categorias
        for i in 0 ... categoriasTipo.count{
            if (Constantes.usuario.m_categorias.contains(i)) {
                optIdsCat.append(categoriasContador)
                self.ddCategoria.optionArray.append(categoriasTipo[i])
                categoriasContador+=1
            }
        }
        self.ddCategoria.optionIds = optIdsCat
        
        ddCategoria.rowBackgroundColor = .lightGray
        ddCategoria.selectedRowColor = .green
        
        ddCategoria.didSelect{(selectedText , index ,id) in
            self.categoria = id
        }
        
        if (Constantes.usuario.m_tipo == Constantes.USER_RESTAURANTERO){
            self.tfPrecio.placeholder = "Precio por ración"
        }
        else{
            self.tfPrecio.placeholder = "Precio por Kg"
        }
    }
    

    func textViewDidBeginEditing(_ textView: UITextView) {
        if tvDescripcion.textColor == UIColor.lightGray {
            tvDescripcion.text = nil
            tvDescripcion.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if tvDescripcion.text.isEmpty {
            tvDescripcion.text = placeholder
            tvDescripcion.textColor = UIColor.lightGray
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
         return false
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    
    @IBAction func agregarProducto(_ sender: UIButton) {
        if (tfNombre.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            present(mostrarMsj(error: Constantes.NOMBRE_PRODUCTO), animated: true, completion: nil)
            return
        }
        
        if (self.categoria < 0 || self.categoria > self.ddCategoria.optionArray.count) {
            present(mostrarMsj(error: Constantes.CATEGORIA), animated: true, completion: nil)
            return
        }
        if (tvDescripcion.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || tvDescripcion.text?.trimmingCharacters(in: .whitespacesAndNewlines) == self.placeholder) {
            present(mostrarMsj(error: Constantes.DESCRIPCION), animated: true, completion: nil)
            return
        }
        if (tfPrecio.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            present(mostrarMsj(error: Constantes.PRECIO_VACIO), animated: true, completion: nil)
            return
        }
        
        let referencia = Constantes.db.collection("productos").document()
        
        if  let precio = Double(tfPrecio.text!) {

            if (self.foto != nil) {
                
                let data = foto.pngData()
                Constantes.storage.child("fotosProducto/"+referencia.documentID+".png").putData(data!, metadata: nil, completion: {_, error in
                    if error == nil {
                        
                        //el registro en firebase es correcto guardamos usuario en base de datos
                        referencia.setData(["nombre": self.tfNombre.text!, "nombre_query": self.tfNombre.text!.lowercased(), "categoria": self.ddCategoria.optionArray[self.categoria], "descripcion": self.tvDescripcion.text!, "precio": precio, "foto":"fotosProducto/"+referencia.documentID+".png", "uid": Constantes.usuario.m_uid]){ [self] err in
                            if let err = err {
                                //error actualizar fireabse
                                self.present(mostrarMsj(error: Constantes.ERROR_FOTO_FB), animated: true, completion: nil)
                            }
                            else {
                                //mensaje de confirmación
                                self.present(mostrarMsj(error: Constantes.PRODUCTO_OK), animated: true, completion: nil)
                                //lo agregamos en la tabla de la vista anterior
                                delegado.agregarProducto(producto: Producto(nombre: self.tfNombre.text!, categoria: self.ddCategoria.optionArray[self.categoria], descripcion: self.tvDescripcion.text!, precio: precio, imagen: self.foto, uidProducto: referencia.documentID, uidVendedor: Constantes.usuario.m_uid!))
                                //reseteamos los valores para seguir agregando
                                self.tfNombre.text = ""
                                self.categoria = -1
                                self.ddCategoria.selectedIndex = -1
                                self.ddCategoria.text = ""
                                self.tvDescripcion.text = ""
                                self.tfPrecio.text = ""
                                self.foto = UIImage(named: "fotoNoDisponible")
                                self.imgFoto.image = self.foto


                            }
                        }
                    }
                    else {
                        //error storage
                        self.present(mostrarMsj(error: Constantes.ERROR_FOTO_ST), animated: true, completion: nil)
                        return
                    }
                })
            }
            else {
                //el registro en firebase es correcto guardamos usuario en base de datos
                referencia.setData(["nombre": tfNombre.text!, "nombre_query": tfNombre.text!.lowercased(), "categoria": self.ddCategoria.optionArray[self.categoria], "descripcion": tvDescripcion.text!, "precio": precio, "foto":"", "uid": Constantes.usuario.m_uid]){ err in
                    if let err = err {
                        //error actualizar fireabse
                        self.present(mostrarMsj(error: Constantes.ERROR_FOTO_FB), animated: true, completion: nil)
                    }
                    else {
                        //mensaje de confirmación
                        self.present(mostrarMsj(error: Constantes.PRODUCTO_OK), animated: true, completion: nil)
                        //lo agregamos en la tabla de la vista anterior
                        self.delegado.agregarProducto(producto: Producto(nombre: self.tfNombre.text!, categoria: self.ddCategoria.optionArray[self.categoria], descripcion: self.tvDescripcion.text!, precio: precio, imagen: UIImage(named: "fotoNoDisponible"), uidProducto: referencia.documentID, uidVendedor: Constantes.usuario.m_uid!))
                        //reseteamos los valores para seguir agregando
                        self.tfNombre.text = ""
                        self.categoria = -1
                        self.ddCategoria.selectedIndex = -1
                        self.ddCategoria.text = ""
                        self.tvDescripcion.text = ""
                        self.tfPrecio.text = ""
                    }
                }
            }
        }
        else {
            present(mostrarMsj(error: Constantes.PRECIO_NUMERO), animated: true, completion: nil)
        }
    }
    
    @IBAction func agregarFoto(_ sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - Métodos de delgado UIImage Picker Controller
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.foto = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imgFoto.image = foto
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
