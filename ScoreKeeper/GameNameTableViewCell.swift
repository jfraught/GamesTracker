//
//  GameNameTableViewCell.swift
//  ScoreKeeper
//
//  Created by Jordan Fraughton on 4/2/24.
//

import UIKit

protocol GameNameTableViewCellDelegate: AnyObject {
    func nameTextFieldChanged(sender: GameNameTableViewCell)
}

class GameNameTableViewCell: UITableViewCell, UITextViewDelegate {
    weak var delegate: GameNameTableViewCellDelegate?
    @IBOutlet var gameNameLabel: UITextField!

    @IBAction func gameNameLabelChanged(_ sender: UITextField) {
        delegate?.nameTextFieldChanged(sender: self)
    }

    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}
