//
//  SelectTeamTableViewCell.swift
//  cricket
//
//  Created by mobiledev on 25/5/2024.
//

import UIKit

class SelectTeamTableViewCell: UITableViewCell {

    
    @IBOutlet weak var teamNameLabel: UILabel!
    
    @IBOutlet weak var checkButton: UIButton!
    
    override func awakeFromNib() {

        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
    }
    var isSelectedTeam: Bool = false {
        didSet {
            if isSelectedTeam {
                checkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                teamNameLabel.textColor = UIColor.blue.withAlphaComponent(0.2)
            } else {
                checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
                teamNameLabel.textColor = UIColor.black // or any other color you prefer
            }
        }
    }

}
