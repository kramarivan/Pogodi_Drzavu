//
//  PogodiDrzavuIntegrationTests.swift
//  PogodiDrzavuTests
//
//  Created by Ivan Kramar on 30.06.2024..
//

import XCTest
@testable import PogodiDrzavu

final class PogodiDrzavuIntegrationTests: XCTestCase {

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

    func testSetupNewRoundIntegration() throws {

        viewModel.setupNewRound()
        
        XCTAssertEqual(viewModel.countries.count, 2)
        XCTAssertEqual(viewModel.countries.map { $0.name }, ["Germany", "France"])
        
        XCTAssertNotNil(viewModel.currentCountry)
        
        XCTAssertFalse(viewModel.showAnswers)
        XCTAssertFalse(viewModel.allAnswersSubmitted)
        XCTAssertFalse(viewModel.allPlayersReady)
        XCTAssertEqual(viewModel.players[0].selectedAnswer, nil)
        XCTAssertEqual(viewModel.players[0].isAnswerCorrect, nil)
        XCTAssertEqual(viewModel.players[0].playerReady, false)
    }

    func testSelectAnswerIntegration() throws {
        
        viewModel.setupNewRound()
        
        guard let correctAnswer = viewModel.questionAnswerGenerator.currentQuestion?.name else {
            XCTFail("Current question is not set.")
            return
        }
        
        viewModel.selectAnswer(for: 0, answer: correctAnswer)
        
        XCTAssertTrue(viewModel.players[0].isAnswerCorrect ?? false)
        XCTAssertEqual(viewModel.players[0].score, 5)
        
        let incorrectAnswer = viewModel.countries.first {
            $0.name != correctAnswer
        }?.name ?? ""
        
        viewModel.selectAnswer(for: 1, answer: incorrectAnswer)
        
        XCTAssertFalse(viewModel.players[1].isAnswerCorrect ?? false)
        XCTAssertEqual(viewModel.players[1].score, 0)
    }

    func testNextRoundIntegration() throws {

        viewModel.setupNewRound()
        
        viewModel.players[0].playerReady = true
        viewModel.players[1].playerReady = true
        viewModel.allPlayersReady = true
        
        viewModel.nextRound()
        
        XCTAssertEqual(viewModel.currentRound, 2)
        
        XCTAssertFalse(viewModel.showAnswers)
        XCTAssertFalse(viewModel.allAnswersSubmitted)
        XCTAssertFalse(viewModel.allPlayersReady)
        XCTAssertEqual(viewModel.players[0].selectedAnswer, nil)
        XCTAssertEqual(viewModel.players[0].isAnswerCorrect, nil)
        XCTAssertEqual(viewModel.players[0].playerReady, false)
    }
}





