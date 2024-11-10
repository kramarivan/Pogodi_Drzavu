//
//  PogodiDrzavuUITests.swift
//  PogodiDrzavuUITests
//
//  Created by Ivan Kramar on 23.04.2024..
//

import XCTest

final class PogodiDrzavuUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
    }

    func testWelcomeViewButtonVisibilityAfterDelay() throws {
        let app = XCUIApplication()
        let button = app.buttons["POKRENI IGRU"]
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: button, handler: nil)
        
        waitForExpectations(timeout: 4, handler: nil)
        
        XCTAssertTrue(button.exists)
    }
    
    func testNavigationToSettingsView() throws {
        let app = XCUIApplication()
        
        let startButton = app.buttons["POKRENI IGRU"]
        XCTAssertTrue(startButton.exists)
        
        let isHittablePredicate = NSPredicate(format: "isHittable == true")
        expectation(for: isHittablePredicate, evaluatedWith: startButton, handler: nil)
        
        waitForExpectations(timeout: 5, handler: nil)
        
        startButton.tap()
        
        let settingsTitle = app.staticTexts["POSTAVKE IGRE"]
        XCTAssertTrue(settingsTitle.exists)
        
    }

    func testPlayerAddition() throws {
        let app = XCUIApplication()
        
        let button = app.buttons["POKRENI IGRU"]
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: button, handler: nil)
        
        waitForExpectations(timeout: 4, handler: nil)
        
        button.tap()
        
        let textField = app.textFields["Unesi ime igrača"]
        textField.tap()
        textField.typeText("Player1")
        
        let addButton = app.buttons["Dodaj"]
        addButton.tap()
        
        XCTAssertTrue(app.staticTexts["Player1"].exists)
    }
    
    func testPlayerRemoval() throws {
            let app = XCUIApplication()
            
            let button = app.buttons["POKRENI IGRU"]
            let exists = NSPredicate(format: "exists == true")
            expectation(for: exists, evaluatedWith: button, handler: nil)
            
            waitForExpectations(timeout: 4, handler: nil)
            
            button.tap()
            
            let textField = app.textFields["Unesi ime igrača"]
            textField.tap()
            textField.typeText("Player1")
            
            let addButton = app.buttons["Dodaj"]
            addButton.tap()
            
            let playerCell = app.staticTexts["Player1"]
            playerCell.swipeLeft()
            
            let deleteButton = app.buttons["Delete"]
            deleteButton.tap()
            
            XCTAssertFalse(playerCell.exists)
        }
    
    func testStartButtonDisabledWithLessThanTwoPlayers() throws {
        let app = XCUIApplication()
        
        let button = app.buttons["POKRENI IGRU"]
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: button, handler: nil)
        
        waitForExpectations(timeout: 4, handler: nil)
        
        button.tap()
        
        let startButton = app.buttons["START"]
        
        XCTAssertFalse(startButton.isEnabled)
        
        let textField = app.textFields["Unesi ime igrača"]
        textField.tap()
        textField.typeText("Player1")
        
        let addButton = app.buttons["Dodaj"]
        addButton.tap()
        
        XCTAssertFalse(startButton.isEnabled)
        
        textField.tap()
        textField.typeText("Player2")
        addButton.tap()
        
        XCTAssertTrue(startButton.isEnabled)
    }
}


