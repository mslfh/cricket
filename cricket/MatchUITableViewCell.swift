//
//  MatchUITableViewCell.swift
//  cricket
//
//  Created by mobiledev on 20/5/2024.
//

import UIKit

class MatchUITableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var MatchNameLabel: UILabel!
    
    @IBOutlet weak var scoreButton: UIButton!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func scoreButtonTapped(_ sender: Any) {
        // Get the parent table view
           if let tableView = self.superview as? UITableView {
               // Get the indexPath of the cell
               if let indexPath = tableView.indexPath(for: self) {
                   // Get the Match object associated with the indexPath
                   let match = (tableView.delegate as? MatchUITableViewController)?.matches[indexPath.row]
                   // Perform the segue
                   (tableView.delegate as? MatchUITableViewController)?.performSegue(withIdentifier: "ShowMatchScoreSegue", sender: match)
               }
           }
    }
    
}
