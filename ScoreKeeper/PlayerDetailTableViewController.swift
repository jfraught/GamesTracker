//
//  PlayerDetailTableViewController.swift
//  ScoreKeeper
//
//  Created by Jordan Fraughton on 3/28/24.
//

import UIKit

class PlayerDetailTableViewController: UITableViewController, UITextFieldDelegate {
    // MARK: - Outlets

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var scoreTextField: UITextField!
    @IBOutlet var saveButton: UIBarButtonItem!

    // MARK: - Properties

    var player: Player?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Test github")
        if let player {
            navigationItem.title = player.name
            nameTextField.text = player.name
            scoreTextField.text =  String(player.score)
        } else {
            navigationItem.title = "Add Player"
        }

        updateSaveButton()
    }

    // MARK: - Table view data source

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard segue.identifier == "saveUnwind",
                let name = nameTextField.text,
                let score = Int(scoreTextField.text ?? "0") else  { return }

        if player != nil {
            player?.name = name
            player?.score = score
        } else {
            player = Player(name: name, score: score)
        }
    }

    // MARK: - Functions
    func updateSaveButton() {
        let shouldSaveButtonBeEnabled =
            nameTextField.text?.isEmpty == false &&
            scoreTextField.text?.isEmpty == false

        saveButton.isEnabled = shouldSaveButtonBeEnabled
    }

    // MARK: - Actions

    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButton()
    }

    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}
