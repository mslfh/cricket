//
//  MatchScoreViewController.swift
//  cricket
//
//  Created by mobiledev on 25/5/2024.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class MatchScoreViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {

    var match : Match?
    
    var batterPlayer: Player?
    var nextBatterPlayer: Player?
    var bowlerPlayer: Player?
    
    var avaliableBatterPlayers: [Player] = []
    var avaliableBowlerPlayers: [Player] = []
    
    @IBOutlet weak var batterPickerView: UIPickerView!
    
    @IBOutlet weak var bowlerPickerView: UIPickerView!
    
    @IBOutlet weak var matchTitleLabel: UILabel!
    
    @IBOutlet weak var batterTeamLabel: UILabel!
    
    @IBOutlet weak var bowlerTeamLabel: UILabel!

    @IBAction func changeBatterButtonTapped(_ sender: Any) {
        batterPickerView.isHidden = false
    }
    @IBAction func changeBowlerButtonTapped(_ sender: Any) {
        // Filter out the current bowler player from the list temporarily
        var availableBowlerPlayersForSelection = avaliableBowlerPlayers
        if let currentBowler = bowlerPlayer {
            availableBowlerPlayersForSelection = avaliableBowlerPlayers.filter { $0 != currentBowler }
        }
        // Set the filtered list for bowlerPickerView
        avaliableBowlerPlayers = availableBowlerPlayersForSelection
        bowlerPickerView.reloadAllComponents()
        bowlerPickerView.isHidden = false
    }
    
    override func viewDidLoad() {
            super.viewDidLoad()
            batterPickerView.delegate = self
            bowlerPickerView.delegate = self
            batterPickerView.isHidden = true
            bowlerPickerView.isHidden = true
            if let match = match {
                matchTitleLabel.text = match.title
                batterTeamLabel.text = match.batterTeamName
                bowlerTeamLabel.text = match.bowlerTeamName

                fetchPlayersForTeam(teamId: match.batterTeamId) { players in
                    self.avaliableBatterPlayers = players
                    
                    if(self.avaliableBatterPlayers.count == 5){
                        self.batterPickerView.reloadAllComponents()
                    }
                      
                }

                fetchPlayersForTeam(teamId: match.bowlerTeamId) { players in
                    self.avaliableBowlerPlayers = players
                    if(self.avaliableBowlerPlayers.count == 5){
                        self.bowlerPickerView.reloadAllComponents()
                    }
                     
                }
            }
        }

        func fetchPlayersForTeam(teamId: String?, completion: @escaping ([Player]) -> Void) {
            guard let teamId = teamId else {
                print("Team ID is nil.")
                completion([])
                return
            }

            let db = Firestore.firestore()
            let teamsCollection = db.collection("teams")

            teamsCollection.document(teamId).getDocument { teamDocument, error in
                if let teamDocument = teamDocument, let team = try? teamDocument.data(as: Team.self) {
                    if let playerIds = team.playerIds {
                        var players: [Player] = []

                        let playersCollection = db.collection("players")
                        for playerId in playerIds {
                            playersCollection.document(playerId).getDocument { playerDocument, error in
                                if let playerDocument = playerDocument, let player = try? playerDocument.data(as: Player.self) {
                                    players.append(player)
                                    completion(players) // Call completion inside the loop
                                }
                            }
                        }
                    } else {
                        print("Team \(team.teamName) does not have player IDs.")
                        completion([])
                    }
                } else {
                    print("Team document not found for ID: \(teamId)")
                    completion([])
                }
            }
        }
    

    // MARK: - UIPickerViewDelegate and UIPickerViewDataSource Methods
       
       func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           if pickerView == batterPickerView {
               return avaliableBatterPlayers.count
           } else {
               return avaliableBowlerPlayers.count
           }
       }
       
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           if pickerView == batterPickerView {
               return avaliableBatterPlayers[row].name
           } else {
               return avaliableBowlerPlayers[row].name
           }
       }
       
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           if pickerView == batterPickerView {
               batterPlayer = avaliableBatterPlayers[row]
               avaliableBatterPlayers.remove(at: row)
               // Now reload the picker view to update the options
               batterPickerView.reloadAllComponents()
               batterPickerView.isHidden = true
           } else {
               if let currentBowler = bowlerPlayer {
                   avaliableBowlerPlayers.append(currentBowler)
               }
              
               bowlerPlayer = avaliableBowlerPlayers[row]
               bowlerPickerView.isHidden = true
           }
       }

}
