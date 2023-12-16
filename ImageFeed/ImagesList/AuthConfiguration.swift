//
//  Constants.swift
//  ImageFeed
//
//  Created by Рамиль Аглямов on 07.06.2023.
//

import Foundation

enum Constants {
    static let accessKey: String = "89VbQebevIY1Z0ti17nLdG_oYYTrCO3AqKCKFWZVlnE"
    static let secretKey: String = "IrvmYMO3OrHT4NZkaUJfR0w2zNKhR3ZK6dKZHJoaSMo"
    static let redirectURI =  "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes+write_user"
    static let defaultBaseURL = URL (string: "https://api.unsplash.com/")!
}

let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 authURLString: UnsplashAuthorizeURLString,
                                 defaultBaseURL: Constants.defaultBaseURL)
        }
}
