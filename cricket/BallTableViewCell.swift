//
//  BallTableViewCell.swift
//  cricket
//
//  Created by mobiledev on 26/5/2024.
//

import UIKit

class BallTableViewCell: UITableViewCell {

    
    @IBOutlet weak var balltitle: UILabel!
    
    @IBOutlet weak var balltype: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
