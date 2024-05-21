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

class TeamUITableViewController: UITableViewController {

    var teams = [Team]()
    var filteredTeams = [Team]()


    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func unwindToTeamList(sender: UIStoryboardSegue) {
        if let detailScreen = sender.source as? TeamDetailsViewController {
                if let teamIndex = detailScreen.teamIndex {
                    if let filteredIndex = teams.firstIndex(where: { $0.documentID == detailScreen.team?.documentID }) {
                        teams[filteredIndex] = detailScreen.team!
                    }
                }
            filterTeams(for: searchBar.text ?? "")
                tableView.reloadData()
            }
    }

    @IBAction func unwindDeleteToTeamList(sender: UIStoryboardSegue) {
        
        if let detailScreen = sender.source as? TeamDetailsViewController {
                if let teamIndex = detailScreen.teamIndex {
                    if let filteredIndex = teams.firstIndex(where: { $0.documentID == detailScreen.team?.documentID }) {
                        teams.remove(at: filteredIndex)
                    }
                }
            filterTeams(for: searchBar.text ?? "")
                tableView.reloadData()
            }
        
    }

    @IBAction func unwindAddToTeamList(sender: UIStoryboardSegue) {
        // No need to reset teams or call viewDidLoad since the data is already fetched
        teams = [Team]()
        filteredTeams = [Team]()
        fetchTeams()
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        fetchTeams()
    }
    
    func fetchTeams() {
        let db = Firestore.firestore()
        let teamCollection = db.collection("teams")
        teamCollection.getDocuments() { (result, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in result!.documents {
                    let conversionResult = Result {
                        try document.data(as: Team.self)
                    }
                    switch conversionResult {
                    case .success(let team):
                        print(" \(team)")
                        self.teams.append(team)
                    case .failure(let error):
                        print("Error decoding team: \(error)")
                    }
                }
                self.filteredTeams = self.teams // Initialize filteredTeams with all teams initially
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
        return filteredTeams.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamUITableViewCell", for: indexPath)

                let team = filteredTeams[indexPath.row]

                if let teamCell = cell as? TeamUITableViewCell {
                    teamCell.teamNameLabel.text = team.teamName
                }

                return cell
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "ShowTeamDetailSegue" {
            guard let detailViewController = segue.destination as? TeamDetailsViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedTeamCell = sender as? TeamUITableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedTeamCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedTeam = filteredTeams[indexPath.row] // Retrieve from filteredTeams
            
            detailViewController.team = selectedTeam
            detailViewController.teamIndex = indexPath.row
        }
    }
    

}
    // MARK: - UISearchBarDelegate

    extension TeamUITableViewController: UISearchBarDelegate {
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            filterTeams(for: searchText)
        }

        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.text = ""
            filterTeams(for: "")
            searchBar.resignFirstResponder()
        }

        func filterTeams(for searchText: String) {
            if searchText.isEmpty {
                filteredTeams = teams
            } else {
                filteredTeams = teams.filter { $0.teamName.lowercased().contains(searchText.lowercased()) }
            }
            tableView.reloadData()
        }
    }
