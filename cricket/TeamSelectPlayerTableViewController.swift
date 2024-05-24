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
    
    override func viewDidLoad() {
        let db = Firestore.firestore()
        let teamCollection = db.collection("players")
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
                        print(" \(player)")
                        self.players.append(player)
                    case .failure(let error):
                        print("Error decoding team: \(error)")
                    }
                }
                self.tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamSelectPlayerTableViewCell", for: indexPath)

        let player = players[indexPath.row]

        if let playerCell = cell as? TeamSelectPlayerTableViewCell {
            playerCell.playerNameLabel.text = player.name
        }

        return cell
    }
}
