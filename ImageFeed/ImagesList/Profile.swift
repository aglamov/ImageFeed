//
//  Profile.swift
//  ImageFeed
//
//  Created by Рамиль Аглямов on 24.10.2023.
//

import Foundation

struct ProfileResult: Codable {
    var username: String
    var firstName: String?
    var lastName: String?
    var bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

struct UserResult: Codable {
    var profileImage: ProfileImageURL
    
    enum CodingKeys: String, CodingKey {
            case profileImage = "profile_image"
        }
}

struct ProfileImageURL: Codable {
    var small: String?
}

struct Profile {
    var username: String
    var name: String
    var loginName: String
    var bio: String
}

