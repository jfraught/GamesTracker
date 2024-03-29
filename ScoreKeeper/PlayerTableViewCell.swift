//
//  PlayerTableViewCell.swift
//  ScoreKeeper
//
//  Created by Jordan Fraughton on 3/27/24.
//

import UIKit

protocol PlayeTableViewCellDelegate: AnyObject {
    func stepperTapped(sender: PlayerTableViewCell)
}

class PlayerTableViewCell: UITableViewCell {
    weak var delegate: PlayeTableViewCellDelegate?
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var scoreStepper: UIStepper!
    @IBOutlet var scoreLabel: UILabel!
    
    @IBAction func scoreStepperTapped(_ sender: UIStepper) {
        delegate?.stepperTapped(sender: self)
    }
}
