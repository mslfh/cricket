//
//  MatchUITableViewController.swift
//  cricket
//
//  Created by mobiledev on 20/5/2024.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


class MatchUITableViewController: UITableViewController {

    var matches = [Match]()
    
    @IBAction func unwindToList(sender: UIStoryboardSegue)
    {
        if let detailScreen = sender.source as? MatchDetailsViewController
        {
            matches[detailScreen.matchIndex!] = detailScreen.match!
            tableView.reloadData()
        }
    }
    
    
    @IBAction func unwindDeleteToList(sender: UIStoryboardSegue)
    {
        if let detailScreen = sender.source as? MatchDetailsViewController
        {
            matches.remove(at: detailScreen.matchIndex!)
            tableView.reloadData()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = Firestore.firestore()
        let matchCollection = db.collection("matches")
        matchCollection.getDocuments() { (result, err) in
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
                        try document.data(as: Match.self)
                    }
                    switch conversionResult
                    {
                    case .success(let match):
                        print("\(match)")
                        
                        //NOTE THE ADDITION OF THIS LINE
                        self.matches.append(match)
                        
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
        return matches.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchUITableViewCell", for: indexPath)

        let match = matches[indexPath.row]

        if let matchCell = cell as? MatchUITableViewCell
        {
            //populate the cell
            matchCell.MatchNameLabel.text = match.title
        }

        return cell
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        // is this the segue to the details screen? (in more complex apps, there is more than one segue per screen)
        if segue.identifier == "ShowMatchDetailSegue"
        {
              //down-cast from UIViewController to DetailViewController (this could fail if we didn’t link things up properly)
              guard let detailViewController = segue.destination as? MatchDetailsViewController else
              {
                  fatalError("Unexpected destination: \(segue.destination)")
              }

              //down-cast from UITableViewCell to MovieUITableViewCell (this could fail if we didn’t link things up properly)
              guard let selectedMatchCell = sender as? MatchUITableViewCell else
              {
                  fatalError("Unexpected sender: \( String(describing: sender))")
              }

              //get the number of the row that was pressed (this could fail if the cell wasn’t in the table but we know it is)
              guard let indexPath = tableView.indexPath(for: selectedMatchCell) else
              {
                  fatalError("The selected cell is not being displayed by the table")
              }

              //work out which movie it is using the row number
              let selectedMatch = matches[indexPath.row]

              //send it to the details screen
            detailViewController.match = selectedMatch
            detailViewController.matchIndex = indexPath.row
        }
    }
    
}
