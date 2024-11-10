//
//  SettingsViewModel.swift
//  PogodiDrzavu
//
//  Created by Ivan Kramar on 24.04.2024..
//

import Foundation

class SettingsViewModel: ObservableObject {
    @Published var players: [Player] = []
    @Published var selectedDurationIndex = 0
    @Published var selectedRoundIndex = 0
    @Published var selectedContinentIndex = 0
    
    let durations = [5, 10, 15]
    let rounds = [3, 5, 7, 10]
    let continents = ["Europa", "Azija", "Afrika", "Sjeverna i Srednja Amerika", "Južna Amerika"]
    
    init() {
        
    }
    
    func addPlayer(name: String) {
                let newPlayer = Player(name: name, score: 0)
                players.append(newPlayer)
        }
    
    func playerCheck(name: String) -> Bool {
        return players.count > 3 || name.isEmpty || name.count > 15
    }
    
    func removePlayer(at offsets: IndexSet) {
            players.remove(atOffsets: offsets)
        }
    
    func arrowImageName(for index: Int, totalPlayers: Int) -> String {
        if totalPlayers <= 2 {
            return index == 0 ? "arrow.up" : "arrow.down"
        } else if totalPlayers == 3 {
            switch index {
            case 0:
                return "arrow.up.left"
            case 1:
                return "arrow.up.right"
            case 2:
                return "arrow.down"
            default:
                return "arrow.right"
            }
        }else {
            switch index {
            case 0:
                return "arrow.up.left"
            case 1:
                return "arrow.up.right"
            case 2:
                return "arrow.down.left"
            case 3:
                return "arrow.down.right"
            default:
                return "arrow.right"
            }
        }
    }
}
