//
//  TeamSelectPlayerTableViewCell.swift
//  cricket
//
//  Created by mobiledev on 24/5/2024.
//

import UIKit

class TeamSelectPlayerTableViewCell: UITableViewCell {

    
    @IBOutlet weak var playerNameLabel: UILabel!
    
    @IBOutlet weak var checkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Configure the button for unchecked state
        configureButtonForUnchecked()
        // Add tap gesture recognizer to the cell
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        addGestureRecognizer(tapGesture)
        // Add tap event handling to the button
        checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            // Perform the visual feedback here
            playerNameLabel.textColor = UIColor.blue.withAlphaComponent(0.2)
            checkButton.isSelected = true // Change button state to selected
        } else {
            // Reset the appearance if deselected
            playerNameLabel.textColor = UIColor.black
            configureButtonForUnchecked()
        }
    }
    
    // Method to handle tap on the cell
    @objc func cellTapped() {
        isSelected = !isSelected // Toggle the selected state
        if isSelected {
            // Update the button state when selected
            checkButton.isSelected = true
        } else {
            // Reset the button state when deselected
            configureButtonForUnchecked()
        }
    }
    
    // Method to handle the tap event on the checkButton
    @objc func checkButtonTapped() {
        isSelected = !isSelected // Toggle the selected state
        
        if isSelected {
            // Update the button state when selected
            checkButton.isSelected = true
        } else {
            // Reset the button state when deselected
            configureButtonForUnchecked()
        }
    }
    
    // Configure the button for unchecked state
    func configureButtonForUnchecked() {
        checkButton.isSelected = false
        checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
        checkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
    }
}
