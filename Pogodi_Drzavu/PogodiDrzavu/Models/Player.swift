//
//  Player.swift
//  PogodiDrzavu
//
//  Created by Ivan Kramar on 24.04.2024..
//

import Foundation

struct Player: Identifiable {
    let id = UUID()
    var name: String
    var score: Int
    var selectedAnswer: String?
    var isAnswerCorrect: Bool?
    var playerReady: Bool = false
}
