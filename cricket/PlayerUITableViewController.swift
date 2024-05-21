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
    var filteredPlayers = [Player]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func unwindToList(sender: UIStoryboardSegue)
    {
        if let detailScreen = sender.source as? PlayerDetailsViewController {
                if let playerIndex = detailScreen.playerIndex {
                    if let filteredIndex = players.firstIndex(where: { $0.documentID == detailScreen.player?.documentID }) {
                        players[filteredIndex] = detailScreen.player!
                    }
                }
                filterPlayers(for: searchBar.text ?? "")
                tableView.reloadData()
            }
    }
    
    
    @IBAction func unwindDeleteToList(sender: UIStoryboardSegue)
    {
        if let detailScreen = sender.source as? PlayerDetailsViewController {
                if let playerIndex = detailScreen.playerIndex {
                    if let filteredIndex = players.firstIndex(where: { $0.documentID == detailScreen.player?.documentID }) {
                        players.remove(at: filteredIndex)
                    }
                }
                filterPlayers(for: searchBar.text ?? "")
                tableView.reloadData()
            }
    }

    @IBAction func unwindAddToPlayerList(sender: UIStoryboardSegue) {
        
        players = [Player]()
        filteredPlayers = [Player]()
        fetchPlayers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        fetchPlayers()
    }

    func fetchPlayers() {
        let db = Firestore.firestore()
        let playerCollection = db.collection("players")
        playerCollection.getDocuments() { (result, err) in
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
                self.filteredPlayers = self.players // Initialize filteredTeams with all teams initially
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
        return filteredPlayers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerUITableViewCell", for: indexPath)

        let player = filteredPlayers[indexPath.row]

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
              let selectedPlayers = filteredPlayers[indexPath.row]

              //send it to the details screen
              detailViewController.player = selectedPlayers
              detailViewController.playerIndex = indexPath.row
        }
    }
    

}
// MARK: - UISearchBarDelegate

extension PlayerUITableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterPlayers(for: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filterPlayers(for: "")
        searchBar.resignFirstResponder()
    }

    func filterPlayers(for searchText: String) {
        if searchText.isEmpty {
            filteredPlayers = players
        } else {
            filteredPlayers = players.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
}
