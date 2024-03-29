//
//  Player.swift
//  ScoreKeeper
//
//  Created by Jordan Fraughton on 3/27/24.
//

import Foundation

struct Player: Comparable, Codable {
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("players").appendingPathExtension("plist")

    var name: String
    var score: Int
    var id = UUID()

    static var samplePlayers: [Player] {
        return [
            Player(name: "Bob", score: 21),
            Player(name: "Jill", score: 18),
            Player(name: "Terry", score: 15)
        ]
    }

    static func <(lhs: Player, rhs: Player) -> Bool {
        lhs.score > rhs.score
    }

    static func ==(lhs: Player, rhs: Player) -> Bool {
        lhs.id == rhs.id 
    }

    static func loadPlayers() -> [Player]? {
        guard let codedPlayers = try? Data(contentsOf: archiveURL) else { return nil }

        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Player>.self, from: codedPlayers)
    }

    static func savePlayers(_ players: [Player]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedPlayers = try? propertyListEncoder.encode(players)
        try? codedPlayers?.write(to: archiveURL, options: .noFileProtection)
    }
}
