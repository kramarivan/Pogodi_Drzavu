//
//  PogodiDrzavuTests.swift
//  PogodiDrzavuTests
//
//  Created by Ivan Kramar on 23.04.2024..
//

import XCTest
@testable import PogodiDrzavu

final class PogodiDrzavuTests: XCTestCase {

    var viewModel: QuizViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let players = [
            Player(name: "Player1", score: 0),
            Player(name: "Player2", score: 0)
        ]
        
        let countries = [
            Country(name: "Germany", bordersFile: "germany"),
            Country(name: "France", bordersFile: "france")
        ]
        
        viewModel = QuizViewModel(duration: 10, continent: "Europe", numberOfRounds: 3, players: players)
        viewModel.countries = countries
        viewModel.questionAnswerGenerator = QuestionAnswerGenerator(countries: countries, continent: "Europe")
    }

    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }

    func testInitialSetup() throws {
        XCTAssertEqual(viewModel.currentRound, 1)
        XCTAssertFalse(viewModel.showAnswers)
        XCTAssertFalse(viewModel.navigateToResults)
        XCTAssertNil(viewModel.currentCountry)
        XCTAssertFalse(viewModel.allAnswersSubmitted)
        XCTAssertFalse(viewModel.allPlayersReady)
        XCTAssertEqual(viewModel.timeRemaining, 10)
        XCTAssertEqual(viewModel.players.count, 2)
    }

    func testSetupNewRound() throws {
        viewModel.setupNewRound()
        
        print("Countries count: \(viewModel.questionAnswerGenerator.countries.count)")
        print("Current country: \(String(describing: viewModel.currentCountry))")
        
        XCTAssertNotNil(viewModel.currentCountry)
        XCTAssertFalse(viewModel.showAnswers)
        XCTAssertFalse(viewModel.allAnswersSubmitted)
        XCTAssertFalse(viewModel.allPlayersReady)
        XCTAssertEqual(viewModel.players[0].selectedAnswer, nil)
        XCTAssertEqual(viewModel.players[0].isAnswerCorrect, nil)
        XCTAssertEqual(viewModel.players[0].playerReady, false)
    }

    func testMarkPlayerReady() throws {
        viewModel.setupNewRound()
        viewModel.players[0].selectedAnswer = "Germany"
        viewModel.players[1].selectedAnswer = "France"
        viewModel.allAnswersSubmitted = true

        viewModel.markPlayerReady(playerIndex: 0)
        XCTAssertTrue(viewModel.players[0].playerReady)
        XCTAssertFalse(viewModel.allPlayersReady)

        viewModel.markPlayerReady(playerIndex: 1)
        XCTAssertTrue(viewModel.players[1].playerReady)
        XCTAssertTrue(viewModel.allPlayersReady)
    }

    func testNextRound() throws {
        viewModel.setupNewRound()
        viewModel.currentRound = 1
        viewModel.players[0].playerReady = true
        viewModel.players[1].playerReady = true
        viewModel.allPlayersReady = true
        
        viewModel.nextRound()
        
        XCTAssertEqual(viewModel.currentRound, 2)
        XCTAssertFalse(viewModel.navigateToResults)
    }

    func testFinalRound() throws {
        viewModel.setupNewRound()
        viewModel.currentRound = 3
        viewModel.players[0].playerReady = true
        viewModel.players[1].playerReady = true
        viewModel.allPlayersReady = true
        
        viewModel.nextRound()
        
        XCTAssertTrue(viewModel.navigateToResults)
    }
}



