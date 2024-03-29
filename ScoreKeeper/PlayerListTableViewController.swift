//
//  PlayerListTableViewController.swift
//  ScoreKeeper
//
//  Created by Jordan Fraughton on 3/28/24.
//

import UIKit

class PlayerListTableViewController: UITableViewController, PlayeTableViewCellDelegate {
    var players: [Player] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        if let savedPlayers = Player.loadPlayers() {
            players = savedPlayers
        } else {
            players = Player.samplePlayers
        }
        navigationItem.title = "Players"
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as! PlayerTableViewCell

        cell.delegate = self

        let player = players[indexPath.row]
        cell.playerNameLabel.text = player.name
        cell.scoreStepper.value = Double(player.score)
        cell.scoreLabel.text = player.score.description

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            players.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }

        Player.savePlayers(players)
    }

    // MARK: - Functions
    func stepperTapped(sender: PlayerTableViewCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            players[indexPath.row].score = Int(sender.scoreStepper.value)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        players.sort()
        tableView.reloadData()

        Player.savePlayers(players)
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
                let newIndexPath = IndexPath(row: players.count, section: 0)
                players.append(player)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }

        players.sort()
        tableView.reloadData()
        
        Player.savePlayers(players)
    }
}
