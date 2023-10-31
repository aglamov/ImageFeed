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
    
    //   private (set) var avatarURL: String?
    
    private let imageView: UIImageView = {
            let profileImage = UIImage(named: "avatar")
            let imageView = UIImageView(image: profileImage)
            imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
           }()
    
    //    private lazy var avatarImage: UIImageView = {
    //        let imageView = UIImageView()
    //        imageView.image = UIImage(named: "avatar")
    //        imageView.layer.cornerRadius = 35
    //        imageView.clipsToBounds = true
    //
    //        return imageView
    //    }()
    //    private (set) var profile: Profile?
    var textLabel: String = ""
    var textLogin: String = ""
    var textBio: String = ""
    
//    private func addProfileImage () -> UIImageView {
//               lazy var profileImageView: UIImageView = {
//                    let profileImageViewAva = UIImage (imageLiteralResourceName: "profileImage")
//        //
//        //lazy var profileImageView: UIImageView = {
//            
//            //            guard let smallPhoto = profileImage.small else { return }
//            //            self.avatarURL = URL(string: smallPhoto)
//            
//            //  let imageUrl = URL(string: profileImageURL?.small ?? "")
//            //  let imageUrl = URL(string: avatarURL ?? "")
//            //   let smallPhoto = profileImageService.ava?.avaUrl
//            let smallPhoto = ava?.avaUrl
//            let imageUrl = URL(string: smallPhoto ?? "")
//            //  let imageView = UIImageView(image: profileImage)
//            //    let imageUrl = URL(string: imageUrlPath)!
//            let processor = RoundCornerImageProcessor(cornerRadius: 20)
//                  // profileImageView.kf.
//            profileImageView.kf.setImage(with: imageUrl)
//            
//            profileImageView.translatesAutoresizingMaskIntoConstraints = false
//            // return profileImageView
//            
//            return profileImageView
//               }()
//    }
    
    private func addLabelName (text: String) -> UILabel {
        lazy var labelName = UILabel ()
        labelName.text = text
        labelName.textColor = .white
        labelName.font = .systemFont(ofSize: 23, weight: .bold)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        return labelName
    }
    
    private func addLabelEmail (text: String) -> UILabel {
        lazy var labelEmail = UILabel ()
        labelEmail.text = text
        labelEmail.textColor = .gray
        labelEmail.font = .systemFont(ofSize: 13)
        labelEmail.translatesAutoresizingMaskIntoConstraints = false
        return labelEmail
    }
    
    private func addLabelDescription (text: String) -> UILabel {
        lazy var labelDescription = UILabel ()
        labelDescription.text = text
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
        
        //        var  text = profileService.profile?.username
        //        fetchProfileImageURL(username: text ?? "")
        
        
      //  let profileImage = UIImage()
          //     let imageView = UIImageView(image: profileImage)
//                imageView.tintColor = .gray
//                imageView.translatesAutoresizingMaskIntoConstraints = false
//                view.addSubview(imageView)
//                imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
//                imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
//                imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 31).isActive = true
//                imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
    //    let imageView = addProfileImage()
        //UIImage ()
        
        view.addSubview(imageView)
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
       // let imageUrl = URL(string: profileImageURL?.small ?? "")
        //let imageUrl = URL(string: avatarURL ?? "")
        let imageUrl = URL (string: profileImageService.ava?.avaUrl ?? "") //"https://images.unsplash.com/profile-1698249541673-e176daedd0abimage?ixlib=rb-4.0.3&crop=faces&fit=crop&w=32&h=32")
        imageView.kf.setImage(with: imageUrl)
        
        var text = profileService.profile?.name
        let labelName = addLabelName(text: text ?? "Ошибка получения данных")
        view.addSubview(labelName)
        //        text = profileService.profile?.username
        //        fetchProfileImageURL(username: text ?? "")
        
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
        
        profileImageServiceObserver = NotificationCenter.default    // 2
            .addObserver(
                forName: ProfileImageService.DidChangeNotification, // 3
                object: nil,                                        // 4
                queue: .main                                        // 5
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()                                 // 6
            }
        updateAvatar()
        
        //  let imageView = addProfileImage()
        //        let imageView = updateAvatar()
        //        view.addSubview(imageView)
        //        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        //        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        //        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        //        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        //
        //        NSLayoutConstraint.activate([
        //            labelName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
        //            labelName.leadingAnchor.constraint(equalTo: imageView.leadingAnchor)
        //        ])
        
        let logoutButton = addButtonLogout()
        view.addSubview(logoutButton)
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL =  ava?.avaUrl,
            let url = URL(string: profileImageURL)
        else {return}
        
//        let imageView = addProfileImage()
//        
//        view.addSubview(imageView)
//        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
//        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
//        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        //          NSLayoutConstraint.activate([
        //              labelName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
        //              labelName.leadingAnchor.constraint(equalTo: imageView.leadingAnchor)
        //          ])
        
        
        let processor = RoundCornerImageProcessor(cornerRadius: imageView.frame.width)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder.svg"), options: [.processor(processor),.cacheSerializer(FormatIndicatedCacheSerializer.png)])
        let cache = ImageCache.default
        cache.clearDiskCache()
        cache.clearMemoryCache()
    }
    
    private func fetchProfileImageURL(username: String) {
        //guard let username = profile?.username else { return }
        
        profileImageService.fetchProfileImageURL(username: username) { _ in
            //            let imageUrl = URL(string: imageUrlPath)!
            //            let processor = RoundCornerImageProcessor(cornerRadius: 20)
            //            16
            //            imageView.kf.setImage(with: imageUrl,
            //            17
            //            placeholder: UlImage(named: "placeholder.jpeg"),
            //            18
            //            options: [.processor(processor)])
        }
    }
    
    
    
}
