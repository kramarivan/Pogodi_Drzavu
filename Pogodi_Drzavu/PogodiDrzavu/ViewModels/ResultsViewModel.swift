//
//  ResultsViewModel.swift
//  PogodiDrzavu
//
//  Created by Ivan Kramar on 14.05.2024..
//

import Foundation

class ResultsViewModel: ObservableObject {
    @Published var players: [Player]
    private let firebaseStorageService = FirebaseStorageService()
    
    init(players: [Player]) {
        self.players = players
        sortPlayersByScore()
    }
    
    func sortPlayersByScore() {
        players.sort(by: {
            $0.score > $1.score
        })
    }
    
    func saveResults() {
        firebaseStorageService.saveResults(players: players) { result in
            switch result {
            case .success:
                print("Results successfully saved!")
            case .failure(let error):
                print("Error saving results: \(error)")
            }
        }
    }
}
