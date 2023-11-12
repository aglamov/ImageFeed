//
//  Photos.swift
//  ImageFeed
//
//  Created by Рамиль Аглямов on 02.11.2023.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

