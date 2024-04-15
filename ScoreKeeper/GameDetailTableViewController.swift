//
//  GameDetailTableViewController.swift
//  ScoreKeeper
//
//  Created by Jordan Fraughton on 3/28/24.
//

import UIKit

class GameDetailTableViewController: UITableViewController, GameNameTableViewCellDelegate, PlayerTableViewCellDelegate, SettingsTableViewCellDelegate {
    var game: Game?
    var gameName: String?
    var sortByHighestScore: Bool?
    var winnerHasHighestScore: Bool?

    var players: [Player] = []

    var gameNameIndexPath = IndexPath(row: 0, section: 0)
    var sortPlayersIndexPath = IndexPath(row: 1, section: 0)
    var winnerIndexPathPath = IndexPath(row: 2, section: 0)
    var playersSection = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        if let game {
            navigationItem.title = game.name
            gameName = game.name
            players = game.players
            sortByHighestScore = game.sortByHighestScore
            winnerHasHighestScore = game.winnerHasHighestScore
        } else {
            navigationItem.title = "Add game"
            sortByHighestScore = true
            winnerHasHighestScore = true 
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 3 : players.count + 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Settings" : "Players"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == gameNameIndexPath.row {
                let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath) as! GameNameTableViewCell
                if let game {
                    cell.gameNameLabel.text = game.name
                }
                cell.delegate = self
                return cell
            } else if indexPath.row == sortPlayersIndexPath.row {
                let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingsTableViewCell

                cell.sortLabel.text = "Sort players by:"
                if let sortByHighestScore {
                    cell.sortBySegmentedControl.selectedSegmentIndex = sortByHighestScore ? 0 : 1
                }
                cell.delegate = self
                return cell
            } else if indexPath.row == winnerIndexPathPath.row {
                let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingsTableViewCell

                cell.sortLabel.text = "Who wins?"
                if let winnerHasHighestScore {
                    cell.sortBySegmentedControl.selectedSegmentIndex = winnerHasHighestScore ? 0 : 1
                }
                cell.delegate = self
                return cell
            }
        } else if indexPath.section == 1 {
            if indexPath.row < players.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as! PlayerTableViewCell

                cell.delegate = self

                let player = players[indexPath.row]
                cell.playerNameLabel.text = player.name
                cell.scoreStepper.value = Double(player.score)
                cell.scoreLabel.text = player.score.description

                return cell
            } else if indexPath.row == players.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "addPlayerCell", for: indexPath) as! AddPlayerTableViewCell

                return cell
            }
        }

        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            players.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveGameUnwind" ,
                let gameName,
                let sortByHighestScore,
                let winnerHasHighestScore else { return }

        if game != nil {
            game?.name = gameName
            game?.players = sortByHighestScore ? players.sorted(by: >) : players.sorted(by: <)
            game?.sortByHighestScore = sortByHighestScore
            game?.winnerHasHighestScore = winnerHasHighestScore
        } else {
            game = Game(name: gameName,
                        players: players,
                        sortByHighestScore: sortByHighestScore,
                        winnerHasHighestScore: winnerHasHighestScore)
        }
    }

    // MARK: - Functions

    func updateSortOrder() {
        if let sortByHighestScore {
            sortByHighestScore ? players.sort(by: >) : players.sort(by: <)
            tableView.reloadData()
        }
    }

    // MARK: - Delegate Functions

    func nameTextFieldChanged(sender: GameNameTableViewCell) {
        gameName = sender.gameNameLabel.text
    }

    func sortSegmentedControlChanged(sender: SettingsTableViewCell) {
        if sender.sortLabel.text == "Sort players by:" {
            sortByHighestScore = sender.sortBySegmentedControl.selectedSegmentIndex == 0 ? true : false
        } else if sender.sortLabel.text == "Who wins?" {
            winnerHasHighestScore = sender.sortBySegmentedControl.selectedSegmentIndex == 0 ? true : false
        }

        updateSortOrder()
    }

    func stepperTapped(sender: PlayerTableViewCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            players[indexPath.row].score = Int(sender.scoreStepper.value)
            tableView.reloadRows(at: [indexPath], with: .none)
        }

        updateSortOrder()
    }

    // Mark: - Actions
    @IBSegueAction func playeDetailSegueAction(_ coder: NSCoder, sender: Any?) -> UITableViewController? {
        let playerDetailTableViewController = PlayerDetailTableViewController(coder: coder)
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else { return playerDetailTableViewController }

        tableView.deselectRow(at: indexPath, animated: true)

        playerDetailTableViewController?.player = players[indexPath.row]

        return playerDetailTableViewController
    }

    @IBAction func unwind(for unwindSegue: UIStoryboardSegue) {
        guard unwindSegue.identifier == "saveUnwind" else { return }
        let sourceVC = unwindSegue.source as! PlayerDetailTableViewController

        if let player = sourceVC.player {
            if let indexOfExistingPlayer = players.firstIndex(of: player) {
                players[indexOfExistingPlayer] = player
                tableView.reloadRows(at: [IndexPath(row: indexOfExistingPlayer, section: 0)], with: .automatic)
            } else {
                let newIndexPath = IndexPath(row: players.count, section: 1)
                players.append(player)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }

        updateSortOrder()
        tableView.reloadData()
    }
}
