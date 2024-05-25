//
//  MatchSelectTeamTableViewController.swift
//  cricket
//
//  Created by mobiledev on 25/5/2024.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class MatchSelectTeamTableViewController: UITableViewController {

    var teams = [Team]()
    var selectedTeams = [Team]()
    var sourceViewController: UIViewController?
    
    override func viewDidLoad() {
       let db = Firestore.firestore()
       let matchCollection = db.collection("matches")
    
       var matchTeamIds = [String]()
        
        matchCollection.getDocuments() { (matchResult, teamErr) in
                   if let teamErr = teamErr {
                       print("Error getting teams: \(teamErr)")
                   } else {
                      
                       for matchDocument in matchResult!.documents {
                           let matchResult = Result {
                               try matchDocument.data(as: Match.self)
                           }
                           switch matchResult {
                           case .success(let match):
                               if let batterTeamId = match.batterTeamId {
                                   matchTeamIds.append(batterTeamId)
                               }
                               if let bowlerTeamId = match.bowlerTeamId {
                                   matchTeamIds.append(bowlerTeamId)
                               }
                               
                           case .failure(let error):
                               print("Error decoding match: \(error)")
                           }
                       }
                   }
            
                   for team in self.selectedTeams {
                       if let teamId = team.documentID {
                           matchTeamIds.append(teamId)
                       }
                   }
                   
                   
                   // Fetch players who do not belong to any team
                   let teamCollection = db.collection("teams")
                   teamCollection.getDocuments() { (teamResult, playerErr) in
                       if let playerErr = playerErr {
                           print("Error getting players: \(playerErr)")
                       } else {
                           for teamDocument in teamResult!.documents {
                               let conversionResult = Result {
                                   try teamDocument.data(as: Team.self)
                               }
                               switch conversionResult {
                               case .success(let team):
                                   
                                   if !matchTeamIds.contains(team.documentID ?? "") {
                                       self.teams.append(team)
                                   }
                               case .failure(let error):
                                   print("Error decoding team: \(error)")
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
        return teams.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectTeamTableViewCell", for: indexPath) as! SelectTeamTableViewCell
        let team = teams[indexPath.row]
        cell.teamNameLabel.text = team.teamName
        return cell
    }


}
