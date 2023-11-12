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
