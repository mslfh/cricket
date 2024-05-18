//
//  TeamUITableViewController.swift
//  cricket
//
//  Created by mobiledev on 18/5/2024.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class PlayerUITableViewController: UITableViewController {

    var players = [Player]()
    
    @IBAction func unwindToList(sender: UIStoryboardSegue)
    {
        if let detailScreen = sender.source as? PlayerDetailsViewController
        {
            players[detailScreen.playerIndex!] = detailScreen.player!
            tableView.reloadData()
        }
    }
    
    
    @IBAction func unwindDeleteToList(sender: UIStoryboardSegue)
    {
        if let detailScreen = sender.source as? PlayerDetailsViewController
        {
            players.remove(at: detailScreen.playerIndex!)
            tableView.reloadData()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = Firestore.firestore()
        let playerCollection = db.collection("players")
        playerCollection.getDocuments() { (result, err) in
            if let err = err
            {
                print("Error getting documents: \(err)")
            }
            else
            {
                for document in result!.documents
                {
                    let conversionResult = Result
                    {
                        try document.data(as: Player.self)
                    }
                    switch conversionResult
                    {
                    case .success(let player):
                        print("\(player)")
                        
                        //NOTE THE ADDITION OF THIS LINE
                        self.players.append(player)
                        
                    case .failure(let error):
                     
                        print("Error decoding \(error)")
                    }
                }
                
                //NOTE THE ADDITION OF THIS LINE
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerUITableViewCell", for: indexPath)

        let player = players[indexPath.row]

        if let playerCell = cell as? PlayerUITableViewCell
        {
            //populate the cell
            playerCell.playerNameLabel.text = player.name
        }

        return cell
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        // is this the segue to the details screen? (in more complex apps, there is more than one segue per screen)
        if segue.identifier == "ShowPlayerDetailSegue"
        {
              //down-cast from UIViewController to DetailViewController (this could fail if we didn’t link things up properly)
              guard let detailViewController = segue.destination as? PlayerDetailsViewController else
              {
                  fatalError("Unexpected destination: \(segue.destination)")
              }

              //down-cast from UITableViewCell to MovieUITableViewCell (this could fail if we didn’t link things up properly)
              guard let selectedPlayerCell = sender as? PlayerUITableViewCell else
              {
                  fatalError("Unexpected sender: \( String(describing: sender))")
              }

              //get the number of the row that was pressed (this could fail if the cell wasn’t in the table but we know it is)
              guard let indexPath = tableView.indexPath(for: selectedPlayerCell) else
              {
                  fatalError("The selected cell is not being displayed by the table")
              }

              //work out which movie it is using the row number
              let selectedPlayers = players[indexPath.row]

              //send it to the details screen
              detailViewController.player = selectedPlayers
              detailViewController.playerIndex = indexPath.row
        }
    }
    

}
