//
//  PogodiDrzavuUITestsLaunchTests.swift
//  PogodiDrzavuUITests
//
//  Created by Ivan Kramar on 23.04.2024..
//

import XCTest

final class PogodiDrzavuUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
