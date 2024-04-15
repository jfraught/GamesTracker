//
//  Game.swift
//  ScoreKeeper
//
//  Created by Jordan Fraughton on 4/1/24.
//

import Foundation

struct Game: Codable, Equatable {
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("games").appendingPathExtension("plist")

    var name: String
    var players: [Player]
    var sortByHighestScore = true
    var winnerHasHighestScore = true
    var id = UUID()

    var currentWinner: Player {
        if sortByHighestScore {
            winnerHasHighestScore ? players[0] : players[players.count - 1]
        } else {
            winnerHasHighestScore ? players[players.count - 1] : players[0]
        }

    }

    static var sampleGame: [Game] {
        return [
            Game(name: "Dice", players: Player.samplePlayers)
        ]
    }

    static func ==(lhs: Game, rhs: Game) -> Bool {
        lhs.id == rhs.id
    }

    static func loadGames() -> [Game]? {
        guard let codedGames = try? Data(contentsOf: archiveURL) else { return nil }

        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Game>.self, from: codedGames)
    }

    static func saveGames(_ games: [Game]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedGames = try? propertyListEncoder.encode(games)
        try? codedGames?.write(to: archiveURL, options: .noFileProtection)
    }
}
