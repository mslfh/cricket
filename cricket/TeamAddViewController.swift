//
//  TeamAddViewController.swift
//  cricket
//
//  Created by mobiledev on 18/5/2024.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class TeamAddViewController: UIViewController {

    @IBOutlet var teamNameField: UITextField!
    
    @IBOutlet var teamDescriptionField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onAdd(_ sender: Any) {
        
        guard let teamName = teamNameField.text, !teamName.isEmpty else {
                // Handle empty team name
                return
            }
        
        (sender as! UIBarButtonItem).title = "Loading..."
        
        let db = Firestore.firestore()

        // Create a dictionary representing the team data
        let teamData: [String: Any] = [
            "teamName": teamName,
            "description": teamDescriptionField.text ?? "" // Use empty string if description field is nil
            // Add more fields if necessary
        ]
        
        // Add the team data to Firestore
        db.collection("teams").addDocument(data: teamData) { error in
            if let error = error {
                // Handle any errors
                print("Error adding team: \(error.localizedDescription)")
            } else {
                // Team added successfully
                print("Team added successfully!")
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
