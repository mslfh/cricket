//
//  PlayerUITableViewCell.swift
//  cricket
//
//  Created by mobiledev on 18/5/2024.
//

import UIKit

class PlayerUITableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet var playerNameLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
