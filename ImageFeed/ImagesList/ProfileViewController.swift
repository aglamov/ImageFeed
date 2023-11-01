//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Рамиль Аглямов on 17.05.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    @objc private func didTapButton(){}
    private var profileService = ProfileService.shared
    private var token = OAuth2TokenStorage.shared.token
    var profile: Profile?
    var ava: Ava?
    let profileImageService = ProfileImageService.shared
    private (set) var profileImageURL: ProfileImageURL?
    private var profileImageServiceObserver: NSObjectProtocol?
    private var profileServiceObserver: NSObjectProtocol?
    
    private let imageView: UIImageView = {
        let profileImage = UIImage(named: "avatar")
        let imageView = UIImageView(image: profileImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var textLabel: String = ""
    private var textLogin: String = ""
    private var textBio: String = ""
    
    private let labelName: UILabel = {
        lazy var labelName = UILabel ()
        labelName.textColor = .white
        labelName.font = .systemFont(ofSize: 23, weight: .bold)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        return labelName
    }()
    
    private let labelEmail: UILabel = {
        lazy var labelEmail = UILabel ()
        labelEmail.textColor = .gray
        labelEmail.font = .systemFont(ofSize: 13)
        labelEmail.translatesAutoresizingMaskIntoConstraints = false
        return labelEmail
    }()
    
    private let labelDescription: UILabel = {
        lazy var labelDescription = UILabel ()
        labelDescription.textColor = .white
        labelDescription.font = .systemFont(ofSize: 13)
        labelDescription.translatesAutoresizingMaskIntoConstraints = false
        return labelDescription
    }()
    
    private func addLabelName (text: String) -> UILabel {
        labelName.text = text
        return labelName
    }
    
    private func addLabelEmail (text: String) -> UILabel {
        labelEmail.text = text
        return labelEmail
    }
    
    private func addLabelDescription (text: String) -> UILabel {
        labelDescription.text = text
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
        //ProfileImageService.shared.fetchProfileImageURL(username: username) { _ in}
        //ProfileService.shared.fetchProfile(<#T##token: String##String#>, completion: <#T##(Result<Profile, Error>) -> Void#>)
        profileService.fetchProfile(token!) { result in
            UIBlockingProgressHUD.dismiss()
        }
        
        view.addSubview(imageView)
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        
        let imageUrl = URL (string: profileImageService.ava?.avaUrl ?? "")
        let processor = RoundCornerImageProcessor(cornerRadius: 13)//imageView.frame.width)
        imageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "placeholder.svg"), options: [.processor(processor),.cacheSerializer(FormatIndicatedCacheSerializer.png)])
        let cache = ImageCache.default
        cache.clearDiskCache()
        
        var text = profileService.profile?.name
        let labelName = addLabelName(text: text ?? "Ошибка получения данных")
        view.addSubview(labelName)
        
        NSLayoutConstraint.activate([
            labelName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            labelName.leadingAnchor.constraint(equalTo: imageView.leadingAnchor)
        ])
        
        text = profileService.profile?.loginName
        let labelEmail = addLabelEmail(text: text ?? "Ошибка получения данных")
        view.addSubview(labelEmail)
        NSLayoutConstraint.activate([
            labelEmail.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 8),
            labelEmail.leadingAnchor.constraint(equalTo: labelName.leadingAnchor)
        ])
        
        text = profileService.profile?.bio
        let labelDescription = addLabelDescription(text: text ?? "Ошибка получения данных")
        view.addSubview(labelDescription)
        NSLayoutConstraint.activate([
            labelDescription.topAnchor.constraint(equalTo: labelEmail.bottomAnchor, constant: 8),
            labelDescription.leadingAnchor.constraint(equalTo: labelName.leadingAnchor)
        ])
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        
        profileServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateInfo()
            }
        updateAvatar()
        updateInfo()
        
        let logoutButton = addButtonLogout()
        view.addSubview(logoutButton)
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL =  profileImageService.ava?.avaUrl,
            let url = URL(string: profileImageURL)
        else {return}
        
        let processor = RoundCornerImageProcessor(cornerRadius: imageView.frame.width)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder.svg"), options: [.processor(processor),.cacheSerializer(FormatIndicatedCacheSerializer.png)])
        let cache = ImageCache.default
        cache.clearDiskCache()
        cache.clearMemoryCache()
    }
    
    private func updateInfo() {
        labelName.text = profileService.profile?.name
        labelEmail.text = profileService.profile?.loginName
        labelDescription.text = profileService.profile?.bio
    }
    
    
    private func fetchProfile(token:String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.profile = profile
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                
                break
            }
        }
    }
    
}
