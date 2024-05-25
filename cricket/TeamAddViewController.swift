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

class TeamAddViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var teamNameField: UITextField!
    
    @IBOutlet var teamDescriptionField: UITextField!
    
    @IBOutlet weak var selectPlayerTable: UITableView!
    
    
    var players = [Player]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectPlayerTable.dataSource = self
        selectPlayerTable.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindSelectPlayerToTeamAdd(sender: UIStoryboardSegue) {
        if let detailScreen = sender.source as? TeamSelectPlayerTableViewController {
            players = detailScreen.selectedPlayers
            
            for player in players {
                print(player.name)
            }
            selectPlayerTable.reloadData()
            
        }
    }
    
    
    @IBAction func onAdd(_ sender: Any) {
        
        guard let teamName = teamNameField.text, !teamName.isEmpty else {
                // Handle empty team name
                return
            }
        
        (sender as! UIBarButtonItem).title = "Loading..."
        
        let db = Firestore.firestore()
        
        // Extract playerIds from the players array
        let playerIds = players.map { $0.documentID }
        
        // Create a dictionary representing the team data
        let teamData: [String: Any] = [
            "teamName": teamName,
            "description": teamDescriptionField.text ?? "", // Use empty string if description field is nil
            "playerIds": playerIds
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? TeamSelectPlayerTableViewController {
            destinationVC.sourceViewController = self
            destinationVC.selectedPlayers = self.players
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddSelectPlayerUITableViewCell", for: indexPath) as! SelectPlayerTableViewCell

        let player = players[indexPath.row]
        cell.playerNameLabel.text = player.name

        // Handle delete button tap
        cell.onDeleteButtonTapped = { [weak self] in
            // Remove player from array
            self?.players.remove(at: indexPath.row)
            // Reload table view
            tableView.reloadData()
        }

        return cell
    }

}
