//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Рамиль Аглямов on 28.11.2023.
//

import XCTest
@testable import ImageFeed

class ImagesListViewControllerTests: XCTestCase {
    
    var viewController: ImagesListViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController
        _ = viewController.view // Force loading the view
    }
    
    override func tearDown() {
        viewController = nil
        super.tearDown()
    }
    
    func testViewControllerConformsToTableViewDataSource() {
        XCTAssertTrue(viewController.conforms(to: UITableViewDataSource.self), "View controller should conform to the UITableViewDataSource protocol")
    }

    func testViewControllerConformsToTableViewDelegate() {
        XCTAssertTrue(viewController.conforms(to: UITableViewDelegate.self), "View controller should conform to the UITableViewDelegate protocol")
    }

}
