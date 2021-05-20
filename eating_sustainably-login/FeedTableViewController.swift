//
//  FeedTableViewController.swift
//  eating_sustainably-login
//
//  Created by user190188 on 5/17/21.
//

import UIKit
import Firebase

class FeedTableViewController: UITableViewController {
    
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
    }
    override func viewWillAppear(_ animated: Bool) {
        postsCollectionRef.getDocuments{(snapshot, error) in
            if let err = error{
                debugPrint("Error al recuperar datos: \(err)")
            }else{
                guard let snap = snapshot else {return}
                for document in (snap.documents){
                    let data = document.data()

                    let username = data["name"] as? String ?? "Anonymus"
                    let postRec = data["post"] as? String ?? "Nada que decir"
                    let likes = data["likes"] as? Int ?? 0
                    
                    let newFeedPost = FeedPost(author: username, content: postRec, likes: likes)
                    
                    self.posts.append(newFeedPost)
                    
                }
                self.tableView.reloadData()
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
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! FeedTableViewCell
        
        let post = posts[indexPath.row]
        cell.configure(with: post)
        // Configure the cell...

        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
