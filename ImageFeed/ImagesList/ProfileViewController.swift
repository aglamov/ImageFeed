//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Рамиль Аглямов on 17.05.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    @objc private func didTapButton(){}
    
    private func addProfileImage () -> UIImageView {
            lazy var profileImageView: UIImageView = {
            let profileImage = UIImage (imageLiteralResourceName: "profileImage")
            let imageView = UIImageView(image: profileImage)
            imageView.tintColor = .gray
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        return profileImageView
    }
    
    private func addLabelName () -> UILabel {
        lazy var labelName = UILabel ()
        labelName.text = "Рамиль Аглямов"
        labelName.textColor = .white
        labelName.font = .systemFont(ofSize: 23, weight: .bold)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        return labelName
    }
        
    private func addLabelEmail () -> UILabel {
        lazy var labelEmail = UILabel ()
        labelEmail.text = "aglamov@yandex.ru"
        labelEmail.textColor = .gray
        labelEmail.font = .systemFont(ofSize: 13)
        labelEmail.translatesAutoresizingMaskIntoConstraints = false
        return labelEmail
    }
    
    private func addLabelDescription () -> UILabel {
        lazy var labelDescription = UILabel ()
        labelDescription.text = "Hello"
        labelDescription.textColor = .white
        labelDescription.font = .systemFont(ofSize: 13)
        labelDescription.translatesAutoresizingMaskIntoConstraints = false
        return labelDescription
    }
    
    private func addButtonLogout () -> UIButton {
        lazy var logoutButton = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(Self.didTapButton)
            
        )
        logoutButton.tintColor = UIColor(named: "ypRed")
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        return logoutButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = addProfileImage()
        view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        
        let labelName = addLabelName()
        view.addSubview(labelName)
        
        NSLayoutConstraint.activate([
            labelName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            labelName.leadingAnchor.constraint(equalTo: imageView.leadingAnchor)
        ])
        
        
        let labelEmail = addLabelEmail()
        view.addSubview(labelEmail)
        NSLayoutConstraint.activate([
            labelEmail.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 8),
            labelEmail.leadingAnchor.constraint(equalTo: labelName.leadingAnchor)
        ])
        
        
        let labelDescription = addLabelDescription()
        view.addSubview(labelDescription)
        NSLayoutConstraint.activate([
            labelDescription.topAnchor.constraint(equalTo: labelEmail.bottomAnchor, constant: 8),
            labelDescription.leadingAnchor.constraint(equalTo: labelName.leadingAnchor)
        ])
        
                
        let logoutButton = addButtonLogout()
        view.addSubview(logoutButton)
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
    }
}
