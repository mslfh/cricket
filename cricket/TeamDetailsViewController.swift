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

class TeamDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet var teamNameLabel: UITextField!
    
    @IBOutlet var teamDescriptionLabel: UITextField!

    @IBOutlet weak var selectPlayerTable: UITableView!
    
    var team : Team?
    var teamIndex: Int?
    
    var players = [Player]()
    
    @IBAction func unwindSelectPlayerToTeamDetails(sender: UIStoryboardSegue) {
        if let detailScreen = sender.source as? TeamSelectPlayerTableViewController {
            players = detailScreen.selectedPlayers
            
            for player in players {
                print(player.name)
            }
            selectPlayerTable.reloadData()
            
        }
    }
    
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
        
        let playerIds = players.compactMap { $0.documentID }
        team!.playerIds = playerIds
        
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

            
            if let playerIds = displayTeam.playerIds {
                fetchPlayers(for: playerIds)
            }
        }
        selectPlayerTable.dataSource = self
        selectPlayerTable.delegate = self
    }
    
    private func fetchPlayers(for playerIds: [String]) {
            guard !playerIds.isEmpty else {
                // Do nothing if playerIds is empty
                return
            }
        
            let db = Firestore.firestore()
        
            let teamCollection = db.collection("players").whereField(FieldPath.documentID(), in: playerIds)
            teamCollection.getDocuments() { (result, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in result!.documents {
                        let conversionResult = Result {
                            try document.data(as: Player.self)
                        }
                        switch conversionResult {
                        case .success(let player):
                        
                            self.players.append(player)
                        case .failure(let error):
                            print("Error decoding team: \(error)")
                        }
                    }
                    self.selectPlayerTable.reloadData()
                }
            }

        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? TeamSelectPlayerTableViewController {
            destinationVC.sourceViewController = self
            destinationVC.selectedPlayers = players
        }
    }

    // MARK: - UITableViewDataSource methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectPlayerUITableViewCell", for: indexPath) as! SelectPlayerTableViewCell

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
