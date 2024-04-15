//
//  PlayerTableViewCell.swift
//  ScoreKeeper
//
//  Created by Jordan Fraughton on 3/27/24.
//

import UIKit

protocol PlayerTableViewCellDelegate: AnyObject {
    func stepperTapped(sender: PlayerTableViewCell)
}

class PlayerTableViewCell: UITableViewCell {
    weak var delegate: PlayerTableViewCellDelegate?
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var scoreStepper: UIStepper!
    @IBOutlet var scoreLabel: UILabel!
    
    @IBAction func scoreStepperTapped(_ sender: UIStepper) {
        delegate?.stepperTapped(sender: self)
    }
}
