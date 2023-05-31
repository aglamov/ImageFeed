//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Рамиль Аглямов on 17.05.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    @objc private func didTapButton(){}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let profileImage = UIImage (imageLiteralResourceName: "profileImage")
        let imageView = UIImageView(image: profileImage)
        //imageView.image =  "like"
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        let labelName = UILabel ()
        labelName.text = "Рамиль Аглямов"
        labelName.textColor = .white
        labelName.font = .systemFont(ofSize: 23)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelName)
        
        NSLayoutConstraint.activate([
            labelName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            labelName.leadingAnchor.constraint(equalTo: imageView.leadingAnchor)
        ])
        
        let labelEmail = UILabel ()
        labelEmail.text = "aglamov@yandex.ru"
        labelEmail.textColor = .gray
        labelEmail.font = .systemFont(ofSize: 13)
        labelEmail.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelEmail)
        
        NSLayoutConstraint.activate([
            labelEmail.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 8),
            labelEmail.leadingAnchor.constraint(equalTo: labelName.leadingAnchor)
        ])
        
        let labelDescription = UILabel ()
        labelDescription.text = "Hello"
        labelDescription.textColor = .white
        labelDescription.font = .systemFont(ofSize: 13)
        labelDescription.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelDescription)
        
        NSLayoutConstraint.activate([
            labelDescription.topAnchor.constraint(equalTo: labelEmail.bottomAnchor, constant: 8),
            labelDescription.leadingAnchor.constraint(equalTo: labelName.leadingAnchor)
        ])
    
        let logoutButton = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(Self.didTapButton)
        )
        logoutButton.tintColor = .red
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
    }
}
