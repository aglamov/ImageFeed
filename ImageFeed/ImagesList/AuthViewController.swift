//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Рамиль Аглямов on 08.06.2023.
//

import Foundation
import UIKit

final class AuthViewController : UIViewController {
    @objc private func didTapButton(){}
    
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
        
        let loginButton = UIButton()
//        lazy var loginButton = UIButton.systemButton(
//            with: UIImage(),
//            target: self,
//            action: #selector(Self.didTapButton)
//
//        )
        loginButton.setTitle("Войти", for: .normal)
      
        loginButton.setTitleColor(.black, for: .normal)
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
      //  loginButton.titleLabel = "Войти"
        loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -124).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        
        
//        loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 124).isActive = true
//        loginButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16) .isActive = true
////        loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.).isActive = true
//        loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
    
    
}
