//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Рамиль Аглямов on 13.06.2023.
//

import Foundation
import UIKit
import WebKit

final class WebViewViewController : UIViewController, WKUIDelegate {
    @objc private func didTapButton(){
        
    }
    
    private func addBackButton () -> UIButton {
        lazy var backButton = UIButton.systemButton(
            with: UIImage(named: "Backward")!,
            target: self,
            action: #selector(Self.didTapButton)
        )
        
        backButton.tintColor = UIColor(named: "ypBlack")
        backButton.translatesAutoresizingMaskIntoConstraints = false
        return backButton
    }
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .white
        view.addSubview(webView)
                
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let backButton = addBackButton()
        view.addSubview(backButton)
        
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    }
    
}
