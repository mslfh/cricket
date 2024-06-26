//
//  MatchAddViewController.swift
//  cricket
//
//  Created by mobiledev on 21/5/2024.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class MatchAddViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var matchTitleField: UITextField!
    
    @IBOutlet weak var matchDescriptionField: UITextField!
    
    @IBOutlet weak var teamPicker: UIPickerView!
    
    @IBOutlet weak var selectBowlerButton: UIButton!
    
    @IBOutlet weak var selectBatterButton: UIButton!
    
    
    var selectedBowlerTeam: Team?
    var selectedBatterTeam: Team?
    
    var allTeams = [Team]() // Array to hold all available teams
    var availableTeams = [Team]() // Array to hold teams available for selection
    
    override func viewDidLoad() {
            super.viewDidLoad()
            teamPicker.isHidden = true // Hide the picker initially
            teamPicker.delegate = self
            teamPicker.dataSource = self
            
            fetchTeams()
        }
        
        func fetchTeams() {
            let db = Firestore.firestore()
            let matchCollection = db.collection("matches")
         
            var matchTeamIds = Set<String>() // Using Set for faster lookups
            
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
                                matchTeamIds.insert(batterTeamId)
                            }
                            if let bowlerTeamId = match.bowlerTeamId {
                                matchTeamIds.insert(bowlerTeamId)
                            }
                            
                        case .failure(let error):
                            print("Error decoding match: \(error)")
                        }
                    }
                }
                
                // Fetch all teams
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
                                self.allTeams.append(team)
                                if !matchTeamIds.contains(team.documentID ?? "") {
                                    self.availableTeams.append(team)
                                }
                            case .failure(let error):
                                print("Error decoding team: \(error)")
                            }
                        }
                        self.teamPicker.reloadAllComponents()
                    }
                }
            }
        }
    
    @IBAction func selectBowlerTeam(_ sender: Any) {
        teamPicker.isHidden = false
        availableTeams = allTeams.filter { $0.documentID != selectedBatterTeam?.documentID }
        teamPicker.reloadAllComponents()
    }
    
    
    
    @IBAction func selectBatterTeam(_ sender: Any) {
        teamPicker.isHidden = false
        availableTeams = allTeams.filter { $0.documentID != selectedBowlerTeam?.documentID }
        teamPicker.reloadAllComponents()
    }
    
    @IBAction func OnAdd(_ sender: Any) {
        
        
        guard let matchTitle = matchTitleField.text, !matchTitle.isEmpty,
              let bowlerTeamId = selectedBowlerTeam?.documentID,
              let bowlerTeamName = selectedBowlerTeam?.teamName,
              let batterTeamId = selectedBatterTeam?.documentID,
              let batterTeamName = selectedBatterTeam?.teamName else {
            // Handle missing data
            return
        }
        
        let db = Firestore.firestore()
        let matchData: [String: Any] = [
            "title": matchTitle,
            "description": matchDescriptionField.text ?? "",
            "bowlerTeamId": bowlerTeamId,
            "bowlerTeamName": bowlerTeamName,
            "batterTeamId": batterTeamId,
            "batterTeamName": batterTeamName
        ]
        
        db.collection("matches").addDocument(data: matchData) { error in
            if let error = error {
                print("Error adding match: \(error.localizedDescription)")
            } else {
                print("Match added successfully!")
                self.performSegue(withIdentifier: "addSegue", sender: sender)
            }
        }
    }
    
    // MARK: - UIPickerViewDataSource
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return availableTeams.count
        }
        
    // MARK: - UIPickerViewDelegate
           
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return availableTeams[row].teamName
       }
           
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           let selectedTeam = availableTeams[row]
           if let selectedBowlerTeam = selectedBowlerTeam {
               if selectedBowlerTeam.documentID == selectedTeam.documentID {
                   self.selectedBowlerTeam = nil // Deselect the bowler team if selected again
               } else {
                   self.selectedBatterTeam = selectedTeam
               }
           } else {
               self.selectedBowlerTeam = selectedTeam
           }
           teamPicker.isHidden = true
           updateUI()
       }
           
       func updateUI() {
           if let selectedBowlerTeam = selectedBowlerTeam {
               selectBowlerButton.setTitle(selectedBowlerTeam.teamName, for: .normal)
           }
           if let selectedBatterTeam = selectedBatterTeam {
               selectBatterButton.setTitle(selectedBatterTeam.teamName, for: .normal)
           }
       }
   }
