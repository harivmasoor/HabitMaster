//
//  HabitMasterUITestsLaunchTests.swift
//  HabitMasterUITests
//
//  Created by Hari Masoor on 5/4/23.
//

import XCTest

class HabitMasterUITestsLaunchTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLaunch() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Check if the app has launched successfully by verifying the existence of a UI element.
        // You can choose any element that should be visible on the initial screen after the app launch.
        XCTAssertTrue(app.buttons["Add Habit"].exists)
    }
}
