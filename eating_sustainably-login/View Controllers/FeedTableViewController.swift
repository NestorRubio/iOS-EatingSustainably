//
//  FeedTableViewController.swift
//  eating_sustainably-login
//
//  Created by user190188 on 5/17/21.
//

import UIKit
import Firebase

class FeedTableViewController: UITableViewController {
    
    @IBOutlet weak var btnValidar: UIBarButtonItem!
    @IBOutlet weak var btnBuscar: UIBarButtonItem!
    @IBOutlet weak var btnCerrar: UIBarButtonItem!
    
    @IBOutlet weak var btnPublicar: UIBarButtonItem!
    
    let identifier = "FeedTableViewCell"
    
    private var posts = [FeedPost]()
    private var postsCollectionRef : CollectionReference!

    func prepareCell(){
        let nib = UINib(nibName: identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCell()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        postsCollectionRef = Firestore.firestore().collection("posts")
        title = "Feed general"
        //title = Constantes.usuario.m_email
        
        btnValidar.title = "Validar"

        btnBuscar.image = UIImage(systemName: "magnifyingglass")
        btnBuscar.tintColor = .black

        btnCerrar.image = UIImage(systemName: "power")
        btnCerrar.tintColor = .red
        

        // Do any additional setup after loading the view.
        
        if (Constantes.usuario.m_tipo == Constantes.USER_ADMIN){
            btnValidar.isEnabled = true
            navigationItem.rightBarButtonItems = [btnCerrar, btnBuscar, btnPublicar, btnValidar]
        }
        else {
            btnValidar.isEnabled = false
            navigationItem.rightBarButtonItems = [btnCerrar, btnBuscar, btnPublicar]
        }
        handleSpecificChanges()
    }
    
    func queryInFormat() {
            posts.removeAll()
            postsCollectionRef.order(by: "timestamp", descending: true).limit(to: 20).getDocuments{(snapshot, error) in
                if let err = error{
                    debugPrint("Error al recuperar datos: \(err)")
                }else{
                    guard let snap = snapshot else {return}
                    for document in (snap.documents){
                        
                        let post = FeedPost(withDoc: document)
                        self.posts.append(post)
                        
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
        func handleSpecificChanges() {
            
            let collectionRef = postsCollectionRef
            collectionRef!.addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                
                
                self.queryInFormat()
            }
        }
    


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! FeedTableViewCell
        
        let post = posts[indexPath.row]
        cell.configure(with: post)
        // Configure the cell...

        return cell
    }
    
    
    @IBAction func cerrarSesion(_ sender: UIBarButtonItem) {
        do {
            try Constantes.auth.signOut()
        
            let portada = self.storyboard?.instantiateViewController(identifier: Constantes.Storyboard.portadaViewController) as? UINavigationController
            Constantes.usuario = Usuario()
            //mostramos mensajes de confirmacion y vamos a portada cuando el usuario acepta
            self.present(mostrarMsj(error: Constantes.CERRAR_OK, hand: {(action) -> Void in self.view.window?.rootViewController = portada
                                        self.view.window?.makeKeyAndVisible()}), animated: true, completion: nil)
        }
        catch let signOutError as NSError {
            self.present(mostrarMsj(error: Constantes.ERROR_CERRAR), animated: true, completion: nil)
        }
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "home_buscador"{
            let viewBuscador = segue.destination as! BuscadorFeedViewController
        }
        else if segue.identifier == "home_validar"{
            let viewValidar = segue.destination as! ListaValidarTableViewController
        }
        else if segue.identifier == "home_publicar"{
            let viewPost = segue.destination as! ViewControllerCrearPublicacion
        }
    }


}
