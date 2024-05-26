//
//  HistoryDetailViewController.swift
//  cricket
//
//  Created by mobiledev on 26/5/2024.
//

import UIKit

class HistoryDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var history = HistoryBall()
    var balls : [Ball]?
    
    @IBOutlet weak var ballView: UITableView!
    
    @IBOutlet weak var matchTitle: UILabel!
   
    
    @IBOutlet weak var batterTeam: UILabel!
    
    
    @IBOutlet weak var bolwerTeam: UILabel!
    
    
    @IBOutlet weak var finalScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        matchTitle.text = history.matchTitle
        batterTeam.text = history.batterTeam
        bolwerTeam.text = history.bowlerTeam
        finalScore.text = history.finalScore
        balls = history.balls
        
        ballView.dataSource = self
        ballView.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func shareButtonTapped(_ sender: Any) {
        // Prepare JSON data
        let historyData: [String: Any] = [
            "matchTitle": history.matchTitle,
            "batterTeam": history.batterTeam,
            "bowlerTeam": history.bowlerTeam,
            "finalScore": history.finalScore,
            "balls": balls?.map { ["title": $0.title, "type": $0.type] } ?? []
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: historyData, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: .utf8)
            
            // Initialize UIActivityViewController
            let activityViewController = UIActivityViewController(activityItems: [jsonString ?? ""], applicationActivities: nil)
            
            // Present UIActivityViewController
            present(activityViewController, animated: true, completion: nil)
        } catch {
            print("Error creating JSON data: \(error)")
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return balls?.count ?? 0
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BallTableViewCell", for: indexPath) as! BallTableViewCell
               
       if let ball = balls?[indexPath.row] {
           cell.balltitle.text = ball.title
           cell.balltype.text = ball.type
       }
       
       return cell
    }

}
