//
//  PlayerAddViewController.swift
//  cricket
//
//  Created by mobiledev on 21/5/2024.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class PlayerAddViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var playerNameField: UITextField!
    
    
    @IBOutlet weak var playerDescriptionField: UITextField!
    
    @IBAction func OnAdd(_ sender: Any) {
        guard let playName = playerNameField.text, !playName.isEmpty else {
                // Handle empty name
                return
            }
        
        (sender as! UIBarButtonItem).title = "Loading..."
        
        let db = Firestore.firestore()

        // Create a dictionary representing the team data
        let playerData: [String: Any] = [
            "name": playName,
            "description": playerDescriptionField.text ?? ""
        ]
        
        // Add the team data to Firestore
        db.collection("players").addDocument(data: playerData) { error in
            if let error = error {
                // Handle any errors
                print("Error adding match: \(error.localizedDescription)")
            } else {
                // Team added successfully
                print("player added successfully!")
                self.performSegue(withIdentifier: "addSegue", sender: sender)
            }
    
        }
    }
    
}
