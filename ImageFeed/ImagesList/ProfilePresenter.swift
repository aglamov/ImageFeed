//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Рамиль Аглямов on 25.11.2023.
//

import Foundation
import UIKit

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func loadUrl () -> URL?
    func logout()
}

final class ProfilePresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    let profileImageService = ProfileImageService.shared
    
    
    func loadUrl () -> URL? {
        let profileImageURL =  profileImageService.profileImageURL?.small
        let url = URL(string: profileImageURL ?? "")
        return url 
    }
    
    func viewDidLoad() {
        guard
            let url = loadUrl()
        else { return }
        view?.updateAvatar(url: url)
    }
    
    func logout() {
        DispatchQueue.main.async {
            OAuth2TokenStorage.shared.token = nil
            WebViewViewController.clean()
            if let window = UIApplication.shared.windows.first {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let mainViewController = storyboard.instantiateInitialViewController() {
                    window.rootViewController = mainViewController
                }
            }
        }
    }
}
