//
//  HabitMasterUITests.swift
//  HabitMasterUITests
//
//  Created by Hari Masoor on 5/4/23.
//

import XCTest

class HabitMasterUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // Attach the app to the testing environment.
        let app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddHabit() throws {
        let app = XCUIApplication()

        // Tap on the 'Add Habit' button
        app.buttons["Add Habit"].tap()

        // Enter habit name
        let habitNameField = app.textFields["Habit Name"]
        habitNameField.tap()
        habitNameField.typeText("Test Habit")

        // Enter habit description
        let habitDescriptionField = app.textFields["Habit Description"]
        habitDescriptionField.tap()
        habitDescriptionField.typeText("This is a test habit description.")

        // Save the habit
        app.buttons["Save"].tap()

        // Check if the habit is added to the list
        XCTAssertTrue(app.staticTexts["Test Habit"].exists)
    }
}
