//
//  MatchAddViewController.swift
//  cricket
//
//  Created by mobiledev on 21/5/2024.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class MatchAddViewController: UIViewController {

    
    @IBOutlet weak var matchTitleField: UITextField!
    
    
    @IBOutlet weak var matchDescriptionField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func OnAdd(_ sender: Any) {
        guard let matchTitle = matchTitleField.text, !matchTitle.isEmpty else {
                // Handle empty name
                return
            }
        
        (sender as! UIBarButtonItem).title = "Loading..."
        
        let db = Firestore.firestore()

        // Create a dictionary representing the team data
        let matchData: [String: Any] = [
            "title": matchTitle,
            "description": matchDescriptionField.text ?? ""
        ]
        
        // Add the team data to Firestore
        db.collection("matches").addDocument(data: matchData) { error in
            if let error = error {
                // Handle any errors
                print("Error adding match: \(error.localizedDescription)")
            } else {
                // Team added successfully
                print("match added successfully!")
                self.performSegue(withIdentifier: "addSegue", sender: sender)
            }
    
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
