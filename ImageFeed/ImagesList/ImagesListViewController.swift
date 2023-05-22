//
//  ViewController.swift
//  ImageFeed
//
//  Created by Рамиль Аглямов on 04.05.2023.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private let photosName: [String] = Array(0..<22).map{ "\($0)" }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            if segue.identifier == "ShowSingleImage" { // 1
//                let viewController = segue.destination as! SingleImageViewController // 2
//                let indexPath = sender as! IndexPath // 3
//                let image = UIImage(named: photosName[indexPath.row]) // 4
//                viewController.singleImage.image = image // 5
//            } else {
//                super.prepare(for: segue, sender: sender) // 6
//            }
//        }
           
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSingleImage" {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let image = UIImage(named: photosName[indexPath.row])
            _ = viewController.view // CRASH FIXED !?
            viewController.singleImage.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return
        }

        cell.cellImage.image = image
        cell.dateLabel.text = dateFormatter.string(from: Date())

        let isLiked = indexPath.row % 2 == 1
        let likeImage = isLiked ? UIImage(named: "Like") : UIImage(named: "noLike")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
    
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowSingleImage", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
            
            guard let imageListCell = cell as? ImagesListCell else {
                return UITableViewCell()
            }
            
            configCell(for: imageListCell, with: indexPath)
            return imageListCell
        }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }

}
