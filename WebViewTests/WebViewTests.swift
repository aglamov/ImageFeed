//
//  WebViewTests.swift
//  ImageFeedTests
//
//  Created by Рамиль Аглямов on 23.11.2023.
//
@testable import ImageFeed
import XCTest

final class WebViewTests: XCTestCase {
    final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
        var presenter: ImageFeed.WebViewPresenterProtocol?
        
        var loadRequestCalled: Bool = false
        
        func load(request: URLRequest) {
            loadRequestCalled = true
        }
        
        func setProgressValue(_ newValue: Float) {
            
        }
        
        func setProgressHidden(_ isHidden: Bool) {
            
        }
    }
    
    final class WebViewPresenterSpy: WebViewPresenterProtocol {
        var viewDidLoadCalled: Bool = false
        var view: WebViewViewControllerProtocol?
        
        func viewDidLoad() {
            viewDidLoadCalled = true
        }
        
        func didUpdateProgressValue(_ newValue: Double) {
            
        }
        
        func code(from url: URL) -> String? {
            return nil
        }
    }
    
    func testViewControllerCallsViewDidLoad() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        let viewController = WebViewViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(viewController.loadRequestCalled)
    }
    
    func testProgressHiddenWhenOne() {
            let authHelper = AuthHelper()
            let presenter = WebViewPresenter(authHelper: authHelper)
            let progress: Float = 1.0
            
            let shouldHideProgress = presenter.shouldHideProgress(for: progress) // return value verification
            
            XCTAssertTrue(shouldHideProgress)
        }
    
    func testCodeFromURL() {
            var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")
            urlComponents?.queryItems = [URLQueryItem(name: "code", value: "test code")]
            guard let url = urlComponents?.url else { return }
            let authHelper = AuthHelper()
            let code = authHelper.code(from: url)
            
            XCTAssertEqual(code, "test code")
        }
}
