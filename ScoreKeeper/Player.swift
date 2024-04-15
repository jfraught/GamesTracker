//
//  Player.swift
//  ScoreKeeper
//
//  Created by Jordan Fraughton on 3/27/24.
//

import Foundation

struct Player: Comparable, Codable {
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
        lhs.score < rhs.score
    }

    static func ==(lhs: Player, rhs: Player) -> Bool {
        lhs.id == rhs.id 
    }
}
