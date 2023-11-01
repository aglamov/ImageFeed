//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Рамиль Аглямов on 10.05.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var dateLabel: UILabel!    
    @IBOutlet var likeButton: UIButton!
}
