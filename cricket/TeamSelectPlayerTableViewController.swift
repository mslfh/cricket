//
//  TeamSelectPlayerTableViewController.swift
//  cricket
//
//  Created by mobiledev on 24/5/2024.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class TeamSelectPlayerTableViewController: UITableViewController {
    var players = [Player]()
    var selectedPlayers = [Player]()
    var sourceViewController: UIViewController?
    
    
    @IBAction func OnSelectSave(_ sender: Any) {
        
        if let sourceVC = sourceViewController {
                if sourceVC is TeamAddViewController {
                    self.performSegue(withIdentifier: "saveSelectPlayer", sender: sender)
                } else if sourceVC is TeamDetailsViewController {
                    self.performSegue(withIdentifier: "updateSelectPlayer", sender: sender)
                }
            }
    }
    
    override func viewDidLoad() {
               let db = Firestore.firestore()
               let teamCollection = db.collection("teams")
            
               var teamPlayerIds = [String]()
               // Fetch all teams
               teamCollection.getDocuments() { (teamResult, teamErr) in
                   if let teamErr = teamErr {
                       print("Error getting teams: \(teamErr)")
                   } else {
                      
                       for teamDocument in teamResult!.documents {
                           let teamResult = Result {
                               try teamDocument.data(as: Team.self)
                           }
                           switch teamResult {
                           case .success(let team):
                               if let playerIds = team.playerIds {
                                   for player in playerIds {
                                    teamPlayerIds.append(player)
                                   }
                                
                               }
                           case .failure(let error):
                               print("Error decoding team: \(error)")
                           }
                       }
                   }
                   for player in self.selectedPlayers {
                       if let playerId = player.documentID {
                           teamPlayerIds.append(playerId)
                       }
                   }
                   
                   
                   
                   // Fetch players who do not belong to any team
                   let playerCollection = db.collection("players")
                   playerCollection.getDocuments() { (playerResult, playerErr) in
                       if let playerErr = playerErr {
                           print("Error getting players: \(playerErr)")
                       } else {
                           for playerDocument in playerResult!.documents {
                               let conversionResult = Result {
                                   try playerDocument.data(as: Player.self)
                               }
                               switch conversionResult {
                               case .success(let player):
                                   if !teamPlayerIds.contains(player.documentID ?? "") {
                                       self.players.append(player)
                                   }
                               case .failure(let error):
                                   print("Error decoding player: \(error)")
                               }
                           }
                           self.tableView.reloadData()
                       }
                   }
               }

           }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return players.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamSelectPlayerTableViewCell", for: indexPath) as! TeamSelectPlayerTableViewCell
        let player = players[indexPath.row]
        cell.player = player
        cell.playerNameLabel.text = player.name
        return cell
    }

    
}
