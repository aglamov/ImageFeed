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
    var profileImage: ProfileImage?
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

struct ProfileImage: Codable {
    let small: String?
    let medium: String?
    let large: String?
}

struct Profile {
    var username: String
    var name: String
    var loginName: String
    var bio: String
}

