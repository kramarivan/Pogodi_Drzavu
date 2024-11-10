//
//  QuizViewModel.swift
//  PogodiDrzavu
//
//  Created by Ivan Kramar on 27.04.2024..
//

import Foundation
import SwiftUI
import Combine
import FirebaseStorage

class QuizViewModel: ObservableObject {
    @Published var currentRound = 1
    @Published var showAnswers = false
    @Published var navigateToResults = false
    @Published var currentCountry: String?
    @Published var allAnswersSubmitted: Bool = false
    @Published var allPlayersReady: Bool = false
    @Published var timeRemaining: Int 
    @Published var players: [Player]
    @Published var rotateMap: Bool = false
    
    var countries: [Country] = []
    var questionAnswerGenerator: QuestionAnswerGenerator
    var startOfRoundScores: [Int] = []
    var timer: AnyCancellable?
    let duration: Int
    let continent: String
    let numberOfRounds: Int
    
    init(duration: Int, continent: String, numberOfRounds: Int, players: [Player]) {
        self.duration = duration
        self.continent = continent
        self.numberOfRounds = numberOfRounds
        self.players = players.map { Player(name: $0.name, score: $0.score, selectedAnswer: nil, isAnswerCorrect: nil) }
        self.questionAnswerGenerator = QuestionAnswerGenerator(countries: [], continent: continent)
        self.timeRemaining = duration
        populateCountries()
    }
    
    func populateCountries() {
        questionAnswerGenerator.fetchCountryNames { countryNames in
            self.countries = countryNames.map { Country(name: $0.capitalized, bordersFile: $0.lowercased()) }
            self.questionAnswerGenerator = QuestionAnswerGenerator(countries: self.countries, continent: self.continent)
            self.setupNewRound()
        }
    }
    
    func setupNewRound() {
        guard !self.countries.isEmpty else {
            print("No countries fetched.")
            return
        }
        startOfRoundScores = players.map { $0.score }
        self.questionAnswerGenerator.generateNewQuestion()
        self.currentCountry = self.questionAnswerGenerator.currentQuestion?.bordersFile
        self.showAnswers = false
        self.allAnswersSubmitted = false
        self.allPlayersReady = false
        
        for i in 0..<self.players.count {
            self.players[i].selectedAnswer = nil
            self.players[i].isAnswerCorrect = nil
            self.players[i].playerReady = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.rotateMap = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.showAnswers = true
                self.rotateMap = false
                self.startTimer()
            }
        }
    }
    
    private func startTimer() {
        timer?.cancel()
        timeRemaining = duration
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect().sink { [weak self] _ in
            guard let self = self else { return }
            if self.timeRemaining > 0 && allAnswersSubmitted == false{
                self.timeRemaining -= 1
            } else {
                self.timer?.cancel()
                allAnswersSubmitted = true
            }
        }
    }
    
    func selectAnswer(for playerIndex: Int, answer: String) {
        var player = players[playerIndex]
        if player.selectedAnswer == nil {
            player.selectedAnswer = answer
            player.isAnswerCorrect = (answer == questionAnswerGenerator.currentQuestion?.name)
            if player.isAnswerCorrect ?? false {
                let correctAnswersSubmitted = players.filter { $0.isAnswerCorrect == true }.count
                switch correctAnswersSubmitted {
                case 0:
                    player.score += 5
                case 1:
                    player.score += 3
                case 2:
                    player.score += 2
                case 3:
                    player.score += 1
                default:
                    break
                }
            }
            players[playerIndex] = player 
        }
        allAnswersSubmitted = players.allSatisfy { $0.selectedAnswer != nil }
    }
    
    func markPlayerReady(playerIndex: Int) {
        let player = players[playerIndex]
        if player.playerReady == false {
            players[playerIndex].playerReady = true
            arePlayersReady()
        }
    }
    
    func arePlayersReady() {
        allPlayersReady = players.allSatisfy {
            $0.playerReady == true
        }
        if allPlayersReady {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.nextRound()
            }
        }
    }
    
    func nextRound() {
        if currentRound < numberOfRounds {
            currentRound += 1
            setupNewRound()
        } else {
            navigateToResults = true
        }
    }
}
