//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Рамиль Аглямов on 10.05.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    weak var delegate: ImagesListCellDelegate?
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
    
    func establishLike(isLiked: Bool){
        let like = isLiked ? UIImage(named: "like") : UIImage(named: "dislike")
        likeButton.imageView?.image = like
        likeButton.setImage(like, for: .normal)
    }
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
}
