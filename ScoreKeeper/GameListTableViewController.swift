//
//  GameListTableViewController.swift
//  ScoreKeeper
//
//  Created by Jordan Fraughton on 4/1/24.
//

import UIKit

class GameListTableViewController: UITableViewController {
    // MARK: - Properties

    var games: [Game] = []

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Games"

        if let savedGames = Game.loadGames() {
            games = savedGames
        } else {
            games = Game.sampleGame
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameTableViewCell
        let game = games[indexPath.row]

        cell.gameNameLabel.text = game.name
        cell.leaderLabel.text = "Leader: \(game.currentWinner.name)"

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            games.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }

        Game.saveGames(games)
    }

    // MARK: - Functions

    // MARK: - Actions

    @IBSegueAction func gameDetailSegueAction(_ coder: NSCoder, sender: Any?) -> GameDetailTableViewController? {
        let gameDetailTableViewControllor = GameDetailTableViewController(coder: coder)
        guard let cell = sender as? UITableViewCell,
                let indexPath = tableView.indexPath(for: cell) else { return gameDetailTableViewControllor }

        tableView.deselectRow(at: indexPath, animated: true)

        gameDetailTableViewControllor?.game = games[indexPath.row]

        return gameDetailTableViewControllor
    }
    

    @IBAction func unwind(for unwindSegue: UIStoryboardSegue) {
        guard unwindSegue.identifier == "saveGameUnwind" else { return }
        let sourceVC = unwindSegue.source as! GameDetailTableViewController

        if let game = sourceVC.game {
            if let indexOfExistingGame = games.firstIndex(of: game) {
                games[indexOfExistingGame] = game
                tableView.reloadRows(at: [IndexPath(row: indexOfExistingGame, section: 0)], with: .automatic)
            } else {
                let newIndexPath = IndexPath(row: games.count, section: 0)
                games.append(game)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        Game.saveGames(games)
    }
}
