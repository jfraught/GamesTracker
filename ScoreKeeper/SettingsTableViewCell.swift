//
//  SettingsTableViewCell.swift
//  ScoreKeeper
//
//  Created by Jordan Fraughton on 4/2/24.
//

import UIKit

protocol SettingsTableViewCellDelegate: AnyObject {
    func sortSegmentedControlChanged(sender: SettingsTableViewCell)
}

class SettingsTableViewCell: UITableViewCell {
    weak var delegate: SettingsTableViewCellDelegate?

    // MARK: - Outlets
    @IBOutlet var sortLabel: UILabel!
    @IBOutlet var sortBySegmentedControl: UISegmentedControl!

    // MARK: - Actions
    @IBAction func sortBySegmentedControlChanged(_ sender: UISegmentedControl) {
        delegate?.sortSegmentedControlChanged(sender: self)
    }
}
