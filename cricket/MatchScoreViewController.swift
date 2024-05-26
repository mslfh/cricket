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
    
    
    @IBOutlet weak var wicketLostLabel: UILabel!
    
    @IBOutlet weak var totalRunsLabel: UILabel!
    
    @IBOutlet weak var overLabel: UILabel!
    
    @IBOutlet weak var runRateLabel: UILabel!
    
    @IBOutlet weak var extraLabel: UILabel!
    
    @IBOutlet weak var boundariesLabel: UILabel!
    
    @IBOutlet weak var batterNameLabel: UILabel!
    
    @IBOutlet weak var nextBatterLabel: UILabel!
    
    @IBOutlet weak var batterScoreLabel: UILabel!
    
    @IBOutlet weak var nextBatterScoreLabel: UILabel!
    
    
    @IBOutlet weak var bowlerNameLabel: UILabel!
    
    @IBOutlet weak var bowlerBallsLabel: UILabel!
    
    @IBOutlet weak var bowlerWicketsLabel: UILabel!
    
    @IBOutlet weak var bowlerLostLabel: UILabel!
    
    
    @IBOutlet weak var batterPickerView: UIPickerView!
    
    @IBOutlet weak var bowlerPickerView: UIPickerView!
    
    
    @IBOutlet weak var matchTitleLabel: UILabel!
    
    @IBOutlet weak var batterTeamLabel: UILabel!
    
    @IBOutlet weak var bowlerTeamLabel: UILabel!
    
    
    @IBAction func add1Tapped(_ sender: Any) {
        addRunsToMatch(runs: 1, isNoBall: false, isWideBall: false)
    }
    
    @IBAction func add2Tapped(_ sender: Any) {
        addRunsToMatch(runs: 2, isNoBall: false, isWideBall: false)
        exchangeBatter()
    }
    
    @IBAction func add3Tapped(_ sender: Any) {
        addRunsToMatch(runs: 3, isNoBall: false, isWideBall: false)
    }
    
    @IBAction func add4Tapped(_ sender: Any) {
        addRunsToMatch(runs: 4, isNoBall: false, isWideBall: false)
    }
    
    @IBAction func add5Tapped(_ sender: Any) {
        addRunsToMatch(runs: 5, isNoBall: false, isWideBall: false)
    }
    
    @IBAction func add6Tapped(_ sender: Any) {
        addRunsToMatch(runs: 6, isNoBall: false, isWideBall: false)
    }
    
    @IBAction func noBallTapped(_ sender: Any) {
        addRunsToMatch(runs: 1, isNoBall: true, isWideBall: false)
    }
    
    
    @IBAction func wideTapped(_ sender: Any) {
        addRunsToMatch(runs: 1, isNoBall: false, isWideBall: true)
    }
    
    func addRunsToMatch(runs: Int, isNoBall: Bool, isWideBall: Bool) {
            // Update total runs
            var totalRuns = Int(totalRunsLabel.text ?? "0") ?? 0
            totalRuns += runs
            totalRunsLabel.text = "\(totalRuns)"
            
            // Update extras
            if isNoBall || isWideBall {
                var extras = Int(extraLabel.text ?? "0") ?? 0
                extras += 1
                extraLabel.text = "\(extras)"
            }
            
            // Update boundaries if 4 or 6
            if runs == 4 || runs == 6 {
                var boundaries = Int(boundariesLabel.text ?? "0") ?? 0
                boundaries += 1
                boundariesLabel.text = "\(boundaries)"
            }
            
            // Update batter's score
            var batterScore = Int(batterScoreLabel.text ?? "0") ?? 0
            batterScore += runs
            batterScoreLabel.text = "\(batterScore)"
            
            // Update bowler's stats
            if !isNoBall && !isWideBall {
                var bowlerBalls = Int(bowlerBallsLabel.text ?? "0") ?? 0
                bowlerBalls += 1
                bowlerBallsLabel.text = "\(bowlerBalls)"
            }
            
            // Update over
            let totalBalls = Int(bowlerBallsLabel.text ?? "0") ?? 0
            let overs = totalBalls / 6
            let balls = totalBalls % 6
            overLabel.text = "\(overs).\(balls)"
            
            // Update run rate
            let runRate = (Double(totalRuns) / Double(totalBalls)) * 6.0
            runRateLabel.text = String(format: "%.2f", runRate)
        }
    
    func exchangeBatter(){
        
        // Swap the current batter and next batter
        let tempBatter = batterPlayer
        batterPlayer = nextBatterPlayer
        nextBatterPlayer = tempBatter
        
        // Update the UI with the new batter information
        
        let name = batterNameLabel.text
        batterNameLabel.text = nextBatterLabel.text
        nextBatterLabel.text  = name
        
        
        let score = batterScoreLabel.text
        batterScoreLabel.text = nextBatterScoreLabel.text
        nextBatterScoreLabel.text  = score
        
    }
    
    
    
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
