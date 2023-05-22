//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Рамиль Аглямов on 21.05.2023.
//

import Foundation
import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage!
    
    @IBOutlet weak var singleImage: UIImageView!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            singleImage.image = image
        }
}
