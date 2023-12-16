import XCTest

final class ImageFeed_8_sprintUITests: XCTestCase {
    enum Constraints {
        static let email = ""
        static let password = ""
        static let name = "Ramil Aglyamov"
        static let loginName = "@aglamov"
    }
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["testMode"]
        app.launch()
    }
    
    func testAuth() throws {
    
        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 5))
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 10))
        loginTextField.tap()
        loginTextField.typeText(Constraints.email + "\t")
       // webView.tap()
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        passwordTextField.typeText(Constraints.password)
        
        XCTAssertTrue(webView.buttons["Login"].waitForExistence(timeout: 3))
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }

    
    func testFeed() throws {
        XCTAssertTrue(app.tabBars.buttons.element(boundBy: 0).waitForExistence(timeout: 4))

        let tableQuery = app.tables
        let cell = tableQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 3))
        cell.swipeDown()
        sleep(2)

        let cellTwo = tableQuery.children(matching: .cell).element(boundBy: 1)
        XCTAssertTrue(cellTwo.waitForExistence(timeout: 3))
        XCTAssertTrue(cellTwo.buttons["like"].waitForExistence(timeout: 1))
        cellTwo.buttons["like"].tap()
        sleep(3)
        cellTwo.buttons["like"].tap()
        sleep(3)

        cellTwo.tap()
        sleep(3)

        let image = app.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)

        XCTAssertTrue(app.buttons["BackButton"].waitForExistence(timeout: 3))
        app.buttons["BackButton"].tap()
    }
    
    func testProfile() throws {
        XCTAssertTrue(app.tabBars.buttons.element(boundBy: 1).waitForExistence(timeout: 3))
        
        app.tabBars.buttons.element(boundBy: 1).tap()
        sleep(6)
        XCTAssertTrue(app.staticTexts[Constraints.name].exists)
        XCTAssertTrue(app.staticTexts[Constraints.loginName].exists)

        app.buttons["LogoutButton"].tap()

        XCTAssertTrue(app.alerts["Пока, пока!"].waitForExistence(timeout: 3))
        app.alerts["Пока, пока!"].buttons["Да"].tap()

        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 3))
    }
}
