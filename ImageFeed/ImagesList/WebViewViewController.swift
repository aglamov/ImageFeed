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

final class WebViewViewController : UIViewController, WKUIDelegate {
    @objc private func didTapButton(_ sender: AnyObject){
        //delegate?.webViewViewControllerDidCancel(self)
        if let nvc = navigationController {
                  nvc.popViewController(animated: true)
                  } else {
                      // otherwise, dismiss it
                      dismiss(animated: true, completion: nil)
                  }
          }
    
    
    weak var delegate: WebViewViewControllerDelegate?
    let progressView = UIProgressView(progressViewStyle: .bar)
    
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
        
        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!
        urlComponents.queryItems = [
           URLQueryItem(name: "client_id", value: AccessKey),
           URLQueryItem(name: "redirect_uri", value: RedirectURI),
           URLQueryItem(name: "response_type", value: "code"),
           URLQueryItem(name: "scope", value: AccessScope)
         ]
         let url = urlComponents.url!
        
        let request = URLRequest(url: url)
        webView.load(request)
        
        webView.navigationDelegate = self
        
        
        //let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.progressTintColor = UIColor(named: "ypBlack")
        progressView.trackTintColor = UIColor (named: "ypGray")
        progressView.progress = 0.5
        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressView)
        
        progressView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 0).isActive = true
        progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
    }
    
    
    
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
        
        func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            // NOTE: Since the class is marked as `final` we don't need to pass a context.
            // In case of inhertiance context must not be nil.
            webView.addObserver(
                self,
                forKeyPath: #keyPath(WKWebView.estimatedProgress),
                options: .new,
                context: nil)
            updateProgress()
        }

        func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
        }

        func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == #keyPath(WKWebView.estimatedProgress) {
                updateProgress()
            } else {
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            }
        }

        func updateProgress() {
            progressView.progress = Float(webView.estimatedProgress)
            progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
        }
    }
    
    

    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
}

