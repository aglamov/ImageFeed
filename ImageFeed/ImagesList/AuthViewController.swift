//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Рамиль Аглямов on 08.06.2023.
//

import Foundation
import UIKit

final class AuthViewController : UIViewController {
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
