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
    var historyBall: HistoryBall?
    
    var batterPlayer: Player?
    var nextBatterPlayer: Player?
    var bowlerPlayer: Player?
    
    var avaliableBatterPlayers: [Player] = []
    var avaliableBowlerPlayers: [Player] = []
    
    let outTypes = ["Bowled", "Caught", "Caught and Bowled", "Leg Before Wicket (LBW)", "Run Out", "Hit Wicket", "Stumping"]

    
    @IBOutlet weak var selectInfoLabel: UILabel!
    
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
    
    @IBOutlet weak var outPickerView: UIPickerView!
    
    
    @IBOutlet weak var matchTitleLabel: UILabel!
    
    @IBOutlet weak var batterTeamLabel: UILabel!
    
    @IBOutlet weak var bowlerTeamLabel: UILabel!
    
    
    var totalRuns = 0
    var wickets = 0
    
    var ballsDelivered = 0
    var oversCompleted = 0
    
    var bowlerBalls = 0
    var bowlerWickets = 0
    var bowlerLost = 0
    
    var batterRuns = 0
    var batterBalls = 0
    
    var nextbatterRuns = 0
    var nextbatterBalls = 0
    
    
    @IBAction func dotBallTapped(_ sender: Any) {
        checkOver()
        
        bowlerBalls += 1
        nextbatterBalls += 1
        batterBalls += 1
        bowlerBalls += 1
        
        ballsDelivered += 1
        
        // Check if it's the end of the over
        if ballsDelivered % 6 == 0 {
            
            //choose new bowler
            changeBowler()
            oversCompleted += 1
            ballsDelivered = 0
        }
        
        //update UI
        overLabel.text = "\(oversCompleted).\(ballsDelivered)"
        
        bowlerBallsLabel.text = "\(bowlerBalls)"
        batterScoreLabel.text = "\(batterRuns)(\(batterBalls))"
        nextBatterScoreLabel.text = "\(nextbatterRuns)(\(nextbatterBalls))"
        recordBall(type: "Dot Ball")
    }
    
    
    @IBAction func add1Tapped(_ sender: Any) {
        
        addRunsToMatch(runs: 1, isNoBall: false, isWideBall: false)
        recordBall(type: "Run 1")
    }
    
    @IBAction func add2Tapped(_ sender: Any) {
        addRunsToMatch(runs: 2, isNoBall: false, isWideBall: false)
        recordBall(type: "Run 2")
    }
    
    @IBAction func add3Tapped(_ sender: Any) {
        addRunsToMatch(runs: 3, isNoBall: false, isWideBall: false)
        recordBall(type: "Run 3")
    }
    
    @IBAction func add4Tapped(_ sender: Any) {
        addRunsToMatch(runs: 4, isNoBall: false, isWideBall: false)
        recordBall(type: "Boundary 4")
    }
    
    @IBAction func add5Tapped(_ sender: Any) {
        addRunsToMatch(runs: 5, isNoBall: false, isWideBall: false)
        recordBall(type: "Run 5")
    }
    
    @IBAction func add6Tapped(_ sender: Any) {
        addRunsToMatch(runs: 6, isNoBall: false, isWideBall: false)
        recordBall(type: "Boundary 6")
    }
    
    @IBAction func noBallTapped(_ sender: Any) {
        addRunsToMatch(runs: 1, isNoBall: true, isWideBall: false)
        recordBall(type: "No Ball")
    }
    
    
    @IBAction func wideTapped(_ sender: Any) {
        addRunsToMatch(runs: 1, isNoBall: false, isWideBall: true)
        recordBall(type: "Wide")
    }
    
    
    @IBAction func outTapped(_ sender: Any) {
        
        checkOver()
        
        bowlerBalls += 1
        nextbatterBalls += 1
        wickets += 1
        bowlerWickets += 1
        
        ballsDelivered += 1
        
        // Check if it's the end of the over
        if ballsDelivered % 6 == 0 {
            //choose new bowler
            changeBowler()
            
            oversCompleted += 1
            ballsDelivered = 0
        }
        
        //update UI
        overLabel.text = "\(oversCompleted).\(ballsDelivered)"
        wicketLostLabel.text = "\(wickets)"
        
        bowlerBallsLabel.text = "\(bowlerBalls)"
        bowlerWicketsLabel.text = "\(bowlerWickets)"
        
        nextBatterScoreLabel.text = "\(nextbatterRuns)(\(nextbatterBalls))"
        
        outPickerView.reloadAllComponents()
        outPickerView.isHidden = false
        selectInfoLabel.isHidden = false
        
        recordBall(type: "Out")
    }
    
    
    func recordBall(type: String) {
        
        guard let match = match else { return }
        let ball = Ball(title: "\(oversCompleted).\(ballsDelivered)", type: type)
        if historyBall?.balls == nil {
            historyBall?.balls = []
        }
        historyBall?.balls?.append(ball)
    }
    
    func addRunsToMatch(runs: Int, isNoBall: Bool, isWideBall: Bool) {
        
        if(!selectInfoLabel.isHidden){
            return
        }
        
        checkOver()
        
        // Update extras
        if isNoBall || isWideBall {
            var extras = Int(extraLabel.text ?? "0") ?? 0
            extras += 1
            extraLabel.text = "\(extras)"
            totalRuns += 1
            totalRunsLabel.text = "\(totalRuns)"
            return
        }
        
        
        // update ball
        bowlerBalls += 1
        batterBalls += 1
        nextbatterBalls += 1
        ballsDelivered += 1
        
        // Check if it's the end of the over
        if ballsDelivered % 6 == 0 {
            
            //choose new bowler
            changeBowler()
            
            oversCompleted += 1
            ballsDelivered = 0
        }
       
        // update runs
        totalRuns += runs
        bowlerLost += runs
        batterRuns += runs
        
        if ( runs == 2 || runs == 4 || runs == 6){
            nextbatterRuns += 1
        }
        
        // Update boundaries if 4 or 6
        if (runs == 4 || runs == 6 ){
            var boundaries = Int(boundariesLabel.text ?? "0") ?? 0
            boundaries += 1
            boundariesLabel.text = "\(boundaries)"
        }
        
        //update UI
        totalRunsLabel.text = "\(totalRuns)"
        
        overLabel.text = "\(oversCompleted).\(ballsDelivered)"
        
        bowlerBallsLabel.text = String(bowlerBalls)
        bowlerLostLabel.text = String(bowlerLost)
        
        batterScoreLabel.text = "\(batterRuns)(\(batterBalls))"
        
        nextBatterScoreLabel.text = "\(nextbatterRuns)(\(nextbatterBalls))"
        
            
        // Update run rate
        let totalOvers = Double(oversCompleted) + Double(ballsDelivered) / 6.0
        let runRate = Double(totalRuns) / totalOvers
        runRateLabel.text = String(format: "%.2f", runRate)
        
        //check exchangeBatter
        if (runs == 1 || runs == 3 || runs == 5){
            exchangeBatter()
        }
      
    }
    
    func checkOver() {
        if (ballsDelivered == 5 &&  oversCompleted == 5) || avaliableBatterPlayers.count == 0 {
           
            let alertController = UIAlertController(title: "Game Over", message: "The game is over.", preferredStyle: .alert)
                    
            let mainMenuAction = UIAlertAction(title: "OK", style: .cancel) { _ in
                self.dismiss(animated: true, completion: {
                    self.saveHistoryBallAndDeleteMatch()
                    self.performSegue(withIdentifier: "gameOverSegue", sender: self)
                })
            }
        
            alertController.addAction(mainMenuAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func saveHistoryBallAndDeleteMatch() {
        guard let match = match else { return }
        
        
        historyBall?.matchTitle = match.title
        historyBall?.batterTeam = match.batterTeamName
        historyBall?.bowlerTeam = match.bowlerTeamName
        historyBall?.finalScore = "\(wickets)/\(totalRuns)"
        
        guard let historyBall = historyBall else { return }
        
        let db = Firestore.firestore()
        
        // Save the history ball
        do {
            try db.collection("HistoryBalls").document(historyBall.documentID ?? UUID().uuidString).setData(from: historyBall)
        } catch {
            print("Error saving history ball: \(error)")
        }
        
        // Delete the match document
        db.collection("matches").document(match.documentID ?? "").delete { error in
            if let error = error {
                print("Error deleting match: \(error)")
            } else {
                print("Match successfully deleted")
            }
        }
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
    
    func changeBatter() {
        //choose new batter as current batter player
        batterPickerView.isHidden = false
        selectInfoLabel.isHidden = false
    }
    
    func changeBowler() {
        // Filter out the current bowler player from the list temporarily
        var availableBowlerPlayersForSelection = avaliableBowlerPlayers
        if let currentBowler = bowlerPlayer {
            availableBowlerPlayersForSelection = avaliableBowlerPlayers.filter { $0 != currentBowler }
        }
        // Set the filtered list for bowlerPickerView
        avaliableBowlerPlayers = availableBowlerPlayersForSelection
        bowlerPickerView.reloadAllComponents()
        bowlerPickerView.isHidden = false
        selectInfoLabel.isHidden = false
    }
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
           
            historyBall = HistoryBall()
            
        
            batterPickerView.delegate = self
            bowlerPickerView.delegate = self
            outPickerView.delegate = self
            batterPickerView.isHidden = true
            bowlerPickerView.isHidden = true
            selectInfoLabel.isHidden = true
            outPickerView.isHidden = true
            if let match = match {
                matchTitleLabel.text = match.title
                batterTeamLabel.text = match.batterTeamName
                bowlerTeamLabel.text = match.bowlerTeamName

                fetchPlayersForTeam(teamId: match.batterTeamId) { players in
                    self.avaliableBatterPlayers = players
                    
                    if(self.avaliableBatterPlayers.count == 5){
                       
                        self.batterPlayer =  self.avaliableBatterPlayers[0]
                        self.avaliableBatterPlayers.remove(at: 0)
                        self.nextBatterPlayer =  self.avaliableBatterPlayers[0]
                        self.avaliableBatterPlayers.remove(at: 0)
                        self.batterNameLabel.text = self.batterPlayer?.name
                        self.nextBatterLabel.text = self.nextBatterPlayer?.name
                        
                        self.batterPickerView.reloadAllComponents()
                        
                    }
                      
                }

                fetchPlayersForTeam(teamId: match.bowlerTeamId) { players in
                    self.avaliableBowlerPlayers = players
                    if(self.avaliableBowlerPlayers.count == 5){
                       
                        self.bowlerPlayer =  self.avaliableBowlerPlayers[0]
                        self.bowlerNameLabel.text = self.bowlerPlayer?.name
                        
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
           } else if pickerView == bowlerPickerView {
               return avaliableBowlerPlayers.count
           } else if pickerView == outPickerView {
               return outTypes.count
           }
           return 0
       }
       
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           if pickerView == batterPickerView {
               return avaliableBatterPlayers[row].name
           } else if pickerView == bowlerPickerView {
               return avaliableBowlerPlayers[row].name
           } else if pickerView == outPickerView {
               return outTypes[row]
           }
           return nil
       }
       
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           if pickerView == batterPickerView {
               batterPlayer = avaliableBatterPlayers[row]
               avaliableBatterPlayers.remove(at: row)
               batterPickerView.reloadAllComponents()
               selectInfoLabel.isHidden = true
               batterPickerView.isHidden = true
               batterRuns = 0
               batterBalls = 0
               batterNameLabel.text = batterPlayer?.name
               batterScoreLabel.text = "0(0)"
           } else if pickerView == bowlerPickerView {
               if let currentBowler = bowlerPlayer {
                   avaliableBowlerPlayers.append(currentBowler)
               }
               bowlerPlayer = avaliableBowlerPlayers[row]
               selectInfoLabel.isHidden = true
               bowlerPickerView.isHidden = true
               bowlerBalls = 0
               bowlerWickets = 0
               bowlerLost = 0
               bowlerBallsLabel.text = "0"
               bowlerWicketsLabel.text = "0"
               bowlerLostLabel.text = "0"
               bowlerNameLabel.text = bowlerPlayer?.name
           } else if pickerView == outPickerView {
               let selectedOutType = outTypes[row]
               // Handle the selected out type if needed
               outPickerView.isHidden = true
               batterPickerView.isHidden = false
               batterPickerView.reloadAllComponents()
           }
       }

}
