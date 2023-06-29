//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Рамиль Аглямов on 08.06.2023.
//

import Foundation
import UIKit

final class AuthViewController : UIViewController {
    private let ShowWebViewSegueIdentifier = "ShowWebView"
    
    @objc private func didTapButton(){
        performSegue(withIdentifier: "WebViewSegue", sender: self)
    }
      
    private func addLogoImage () -> UIImageView {
        lazy var profileImageView: UIImageView = {
            let profileImage = UIImage (imageLiteralResourceName: "LogoOfUnsplash")
            let imageView = UIImageView(image: profileImage)
            imageView.tintColor = .white
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        return profileImageView
    }
    
    private func addButtonLogin () -> UIButton {
       
        lazy var loginButton = UIButton(type: .system)
        loginButton.setTitle("Войти", for: .normal)
        loginButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)

        loginButton.setTitleColor(.black, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.bold)

        loginButton.backgroundColor = .white
        loginButton.layer.cornerRadius = 16
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        return loginButton
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(ShowWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = addLogoImage()
        view.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let loginButton = addButtonLogin()
        view.addSubview(loginButton)
        loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -124).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        loginButton.isEnabled = true
    
    }
    
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        OAuth2Service.shared.fetchAuthToken(code) { result in
                        switch result {
                        case .success(let token):
                            OAuth2TokenStorage.shared.token = token
                        case .failure(let error):
                            assertionFailure(code)
                        }
                    }
                   
                }


    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
