//
//  HistoryTableViewController.swift
//  cricket
//
//  Created by mobiledev on 26/5/2024.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


class HistoryTableViewController: UITableViewController {

    
    var history = [HistoryBall]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
           history = [HistoryBall]()
           super.viewWillAppear(animated)
           fetchhistorys()
   }

    func fetchhistorys() {
        let db = Firestore.firestore()
        let playerCollection = db.collection("HistoryBalls")
        playerCollection.getDocuments() { (result, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in result!.documents {
                    let conversionResult = Result {
                        try document.data(as: HistoryBall.self)
                    }
                    switch conversionResult {
                    case .success(let player):
                        self.history.append(player)
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
        return history.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath)

        let his = history[indexPath.row]

        if let hisCell = cell as? HistoryTableViewCell
        {
            //populate the cell
            hisCell.matchTitle.text = his.matchTitle
            hisCell.batterTeam.text = his.batterTeam
            hisCell.bowlerTeam.text = his.bowlerTeam
        
        }

        return cell
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        // is this the segue to the details screen? (in more complex apps, there is more than one segue per screen)
        if segue.identifier == "ShowHistoryDetailSegue"
        {
              //down-cast from UIViewController to DetailViewController (this could fail if we didn’t link things up properly)
              guard let detailViewController = segue.destination as? HistoryDetailViewController else
              {
                  fatalError("Unexpected destination: \(segue.destination)")
              }

              //down-cast from UITableViewCell to MovieUITableViewCell (this could fail if we didn’t link things up properly)
              guard let selectedPlayerCell = sender as? HistoryTableViewCell else
              {
                  fatalError("Unexpected sender: \( String(describing: sender))")
              }

              //get the number of the row that was pressed (this could fail if the cell wasn’t in the table but we know it is)
              guard let indexPath = tableView.indexPath(for: selectedPlayerCell) else
              {
                  fatalError("The selected cell is not being displayed by the table")
              }

              //work out which movie it is using the row number
              let selectedhistory = history[indexPath.row]

              //send it to the details screen
              detailViewController.history = selectedhistory
        }
    }

}
