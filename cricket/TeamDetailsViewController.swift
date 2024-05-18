//
//  TeamDetailsViewController.swift
//  cricket
//
//  Created by mobiledev on 18/5/2024.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class TeamDetailsViewController: UIViewController {

    @IBOutlet var teamNameLabel: UITextField!
    
    @IBOutlet var teamDescriptionLabel: UITextField!
    
    var team : Team?
    var teamIndex: Int?
    
    @IBAction func onDelete(_ sender: Any) {
        (sender as! UIBarButtonItem).title = "Deleting..."
        
        let db = Firestore.firestore()
        do
        {
            //update the database (code from lectures)
            db.collection("teams").document(team!.documentID!).delete(){ err in
                if let err = err {
                    print("Error deleting document: \(err)")
                } else {
                    print("Document successfully deleting")
                    self.performSegue(withIdentifier: "deleteSegue", sender: sender)
                }
            }
        }
    }
    
    @IBAction func onSave(_ sender: Any) {
        (sender as! UIBarButtonItem).title = "Loading..."
        
        let db = Firestore.firestore()

        team!.teamName = teamNameLabel.text!
        team!.description = teamDescriptionLabel.text!
        do
        {
            //update the database (code from lectures)
            try db.collection("teams").document(team!.documentID!).setData(from: team!){ err in
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let displayTeam = team
            {
//            self.navigationItem.title = displayTeam.teamName //this awesome line sets the page title
                teamNameLabel.text = displayTeam.teamName
                teamDescriptionLabel.text = displayTeam.description
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

}
