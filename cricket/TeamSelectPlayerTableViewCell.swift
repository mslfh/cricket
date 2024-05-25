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
    
    var player: Player?
    
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
    
    @objc func cellTapped() {
        isSelected = !isSelected

        if let player = player {
            updateSelectedPlayers(player: player, isSelected: isSelected)
        }

        checkButton.isSelected = isSelected
    }

    @objc func checkButtonTapped() {
        isSelected = !isSelected

        if let player = player {
            updateSelectedPlayers(player: player, isSelected: isSelected)
        }

        checkButton.isSelected = isSelected
    }

    private func updateSelectedPlayers(player: Player, isSelected: Bool) {
        if let tableViewController = findTableViewController() {
            if isSelected {
                tableViewController.selectedPlayers.append(player)
            } else {
                tableViewController.selectedPlayers.removeAll(where: { $0.documentID == player.documentID })
            }
        }
    }

    private func findTableViewController() -> TeamSelectPlayerTableViewController? {
        var view = self.superview
        while let currentView = view {
            if let tableViewController = currentView.next as? TeamSelectPlayerTableViewController {
                return tableViewController
            }
            view = currentView.superview
        }
        return nil
    }
    
    // Configure the button for unchecked state
    func configureButtonForUnchecked() {
        checkButton.isSelected = false
        checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
        checkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
    }
}
