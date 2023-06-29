//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Рамиль Аглямов on 28.06.2023.
//

import Foundation

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    // MARK: - Properties:
    private var userDefaults = UserDefaults.standard
    var token: String? {
        get {
            userDefaults.string(forKey: Keys.bearerToken.rawValue)
        }
        set {
           userDefaults.set(newValue, forKey: Keys.bearerToken.rawValue)
        }
    }
    // MARK: - Keys for UserDefaults:
    private enum Keys: String, CodingKey {
        case bearerToken
    }
}
