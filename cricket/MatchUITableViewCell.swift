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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
