//
//  MatchDetailsViewController.swift
//  cricket
//
//  Created by mobiledev on 20/5/2024.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


class MatchDetailsViewController: UIViewController {

    
    var match : Match?
    var matchIndex: Int?
    
    
    @IBOutlet weak var MatchTitleField: UITextField!
    
    @IBOutlet weak var MatchDescriptionField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let displayMatch = match
            {
//            self.navigationItem.title = displayTeam.teamName
            MatchTitleField.text  = displayMatch.title
            MatchDescriptionField.text  = displayMatch.description
          
            }
        // Do any additional setup after loading the view.
    }

    @IBAction func OnSave(_ sender: Any) {
        (sender as! UIBarButtonItem).title = "Loading..."
        
        let db = Firestore.firestore()

        match!.title = MatchTitleField.text!
        match!.description = MatchDescriptionField.text!
        do
        {
            //update the database (code from lectures)
            try db.collection("matches").document(match!.documentID!).setData(from: match!){ err in
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
    
    @IBAction func OnDelete(_ sender: Any) {
        (sender as! UIBarButtonItem).title = "Deleting..."
        
        let db = Firestore.firestore()
        do
        {
            //update the database (code from lectures)
            db.collection("matches").document(match!.documentID!).delete(){ err in
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
