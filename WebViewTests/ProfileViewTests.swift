////
////  ProfileViewTests.swift
////  ImageFeed
////
////  Created by Рамиль Аглямов on 28.11.2023.
////
//@testable import ImageFeed
//import XCTest
//


@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    final class ProfileViewViewControllerSpy: ProfileViewControllerProtocol {
        var presenter: ImageFeed.ProfileViewPresenterProtocol?
        var viewDidUpdateAvatar = false
        
        func updateAvatar(url: URL) {
            viewDidUpdateAvatar = true
        }
    }
    
    final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
        var viewDidLoadCalled: Bool = false
        var loadDidCalled: Bool = false
        var logoutDidCall: Bool = false
        let testUrl = URL(string: "https://www.google.com")!
        
        var view: ProfileViewControllerProtocol?
        
        func loadUrl() -> URL? {
            loadDidCalled = true
            return testUrl
        }
        
        func logout() {
            logoutDidCall = true
        }
        
        
        func viewDidLoad() {
            viewDidLoadCalled = true
        }
    }
    
    func testPresenterCallsLoadRequest() {
        let viewController = ProfileViewViewControllerSpy()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        let testUrl = URL(string: "https://www.google.com")!
        
        viewController.updateAvatar(url: testUrl)
        
        XCTAssertTrue(viewController.viewDidUpdateAvatar)
    }
}
