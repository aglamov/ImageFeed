//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Рамиль Аглямов on 15.07.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private let keychainStorage = KeychainWrapper.standard
    
    private enum Keys: String {
        case token
    }
    private let tokenKey = "BearerToken"
    
    var token: String? {
        get{
            keychainStorage.string(forKey: tokenKey)
        }
        set {
            if let token = newValue {
                keychainStorage.set(token, forKey: tokenKey)
            } else {
                keychainStorage.removeObject(forKey: tokenKey)
            }
        }
    }
}
//    // MARK: - Properties:
//    private var userDefaults = UserDefaults.standard
//    var token: String? {
//        get {
//            userDefaults.string(forKey: Keys.bearerToken.rawValue)
//        }
//        set {
//           userDefaults.set(newValue, forKey: Keys.bearerToken.rawValue)
//        }
//    }
//    // MARK: - Keys for UserDefaults:
//    private enum Keys: String, CodingKey {
//        case bearerToken
//    }
//}
