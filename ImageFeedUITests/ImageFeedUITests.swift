//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Рамиль Аглямов on 29.11.2023.
//
import XCTest

final class ImageFeedUITests: XCTestCase {
    enum Constraints {
        static let email = "aglamov@yandex.ru"
        static let password = "84295221"
        static let name = "Ramil Aglamov"
        static let login = "@aglamov"
    }
    //переменная приложения
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        //стопнет тесты, если что-то не так
        continueAfterFailure = false
        app.launchArguments = ["testMode"]
        app.launch() //запускаем прилу
    }
    
    func testAuth() throws {
        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 5))
        //нажать на кнопку авторизации
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 10))
        loginTextField.tap()
        loginTextField.typeText(Constraints.email)
        webView.tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        passwordTextField.typeText(Constraints.password)
        webView.swipeUp()
        print(app.debugDescription)
        sleep(3)
        
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
        XCTAssertTrue(cellTwo.buttons["LikeButton"].waitForExistence(timeout: 1))
        cellTwo.buttons["LikeButton"].tap()
        sleep(3)
        cellTwo.buttons["LikeButton"].tap()
        sleep(3)

        cellTwo.tap()
        sleep(3)

        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)

        XCTAssertTrue(app.buttons["BackButton"].waitForExistence(timeout: 3))
        app.buttons["BackButton"].tap()
    }
    
    func testProfile() throws {
        XCTAssertTrue(app.tabBars.buttons.element(boundBy: 1).waitForExistence(timeout: 3))
        app.tabBars.buttons.element(boundBy: 1).tap()

        XCTAssertTrue(app.staticTexts[Constraints.name].exists)
        XCTAssertTrue(app.staticTexts[Constraints.login].exists)

        app.buttons["LogoutButton"].tap()

        XCTAssertTrue(app.alerts["Выход"].waitForExistence(timeout: 3))
        app.alerts["Выход"].buttons["Да"].tap()

        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 3))
    }
}
