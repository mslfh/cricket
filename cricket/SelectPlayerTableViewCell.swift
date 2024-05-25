//
//  SelectPlayerTableViewCell.swift
//  cricket
//
//  Created by mobiledev on 25/5/2024.
//

import UIKit

class SelectPlayerTableViewCell: UITableViewCell {

    @IBOutlet weak var playerNameLabel: UILabel!
    
    
    @IBOutlet weak var deleteItemButton: UIButton!
    
    var onDeleteButtonTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        onDeleteButtonTapped?()
    }
    
}
