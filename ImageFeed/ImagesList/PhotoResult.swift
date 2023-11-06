//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Рамиль Аглямов on 02.11.2023.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let createdAt, description: String?
    let width, height: CGFloat
    let likedByUser: Bool
    let urls: UrlsResult
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case likedByUser = "liked_by_user"
        case id, width, height, description, urls
    }
}

struct UrlsResult: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small : String
    let thumb: String
}
