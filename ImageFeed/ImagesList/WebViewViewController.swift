//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Рамиль Аглямов on 13.06.2023.
//

import Foundation
import UIKit
import WebKit
fileprivate let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController : UIViewController {
    @objc private func didTapBackButton(_ sender: Any?) {
        
    }
    
    weak var delegate: WebViewViewControllerDelegate?
    
    let progressView = UIProgressView (progressViewStyle: .bar)
    let webView = WKWebView()
    
    private func addBackButton () -> UIButton {
        lazy var backButton = UIButton.systemButton(
            with: UIImage(named: "Backward")!,
            target: self,
            action: #selector(Self.didTapBackButton)
        )
        
        backButton.tintColor = UIColor(named: "ypBlack")
        backButton.translatesAutoresizingMaskIntoConstraints = false
        return backButton
    }
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        
        updateProgress()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .white
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        updateProgress()
        let backButton = addBackButton()
        view.addSubview(backButton)
        
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        // наполнение вебвью
        
        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "response_type", value: "code"), //тип ответа
            URLQueryItem(name: "scope", value: AccessScope)
        ]
        let url = urlComponents.url!
        
        updateProgress()
        let request = URLRequest(url: url)
        webView.load(request)
        
        //добавляю навигационный делигат для определения успешной авторизации
        webView.navigationDelegate = self
        
        progressView.trackTintColor = UIColor(named: "ypGray")
        progressView.progressTintColor = UIColor(named: "ypBlack")
        progressView.progress = 0.5
        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressView)
        progressView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 0).isActive = true
        progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
        
        updateProgress()
        
    }
}

extension WebViewViewController : WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) { //1
            //TODO: process code                     //2
            decisionHandler(.cancel) //3
            updateProgress()
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
        } else {
            decisionHandler(.allow) //4
            updateProgress()
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        print (navigationAction.request.url)
        if
            let url = navigationAction.request.url,                         //1
            let urlComponents = URLComponents(string: url.absoluteString),  //2
            urlComponents.path == "/oauth/authorize/native",                //3
            let items = urlComponents.queryItems,                           //4
            let codeItem = items.first(where: { $0.name == "code" })        //5
        {
            return codeItem.value                                           //6
        } else {
            return nil
        }
    }
}

extension WebViewViewController {
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            updateProgress()
        }
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
}

