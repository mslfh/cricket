//
//  HistoryTableViewCell.swift
//  cricket
//
//  Created by mobiledev on 26/5/2024.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var matchTitle: UILabel!
    
    @IBOutlet weak var batterTeam: UILabel!
    
    @IBOutlet weak var bowlerTeam: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
