//
//  PlayerDetailsViewController.swift
//  cricket
//
//  Created by mobiledev on 18/5/2024.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
class PlayerDetailsViewController: UIViewController {

    
    var player : Player?
    var playerIndex: Int?
    
    @IBOutlet var playerNameField: UITextField!
    
    @IBOutlet var playerDescriptionField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let displayPlayer = player
            {
//            self.navigationItem.title = displayTeam.teamName //this awesome line sets the page title
            playerNameField.text = displayPlayer.name
            playerDescriptionField.text = displayPlayer.description
            }
    }
    
    @IBAction func onSave(_ sender: Any) {
        (sender as! UIBarButtonItem).title = "Loading..."
        
        let db = Firestore.firestore()

        player!.name = playerNameField.text!
        player!.description = playerDescriptionField.text!
        
        do
        {
            //update the database (code from lectures)
            try db.collection("players").document(player!.documentID!).setData(from: player!){ err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                    self.performSegue(withIdentifier: "saveSegue", sender: sender)
                }
            }
        } catch { print("Error updating document \(error)")
        } //note "error" is a magic variable
    }
    
    @IBAction func onDelete(_ sender: Any) {
        (sender as! UIBarButtonItem).title = "Deleting..."
        
        let db = Firestore.firestore()
        do
        {
            //update the database (code from lectures)
            db.collection("players").document(player!.documentID!).delete(){ err in
                if let err = err {
                    print("Error deleting document: \(err)")
                } else {
                    print("Document successfully deleting")
                    self.performSegue(withIdentifier: "deleteSegue", sender: sender)
                }
            }
        }
    }
    
}
