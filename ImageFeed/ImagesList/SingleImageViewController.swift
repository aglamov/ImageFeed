//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Рамиль Аглямов on 21.05.2023.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    var imageURL: URL! {
        didSet {
            guard isViewLoaded else {return}

        }
    }
    
    @IBOutlet private weak var shareButton: UIButton!
    
    @IBOutlet private weak var singleImage: UIImageView!
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        let share = UIActivityViewController(
            activityItems: [singleImage as Any],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setImage()
    }

    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
    }
    
    private func setImage() {
        UIBlockingProgressHUD.show()
        singleImage.kf.setImage(with: imageURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let imageResult):
                    self.configureScrollView(with: imageResult.image)
                case .failure:
                    print("Error loading image")
            }
            UIBlockingProgressHUD.dismiss()
        }
    }

    private func configureScrollView(with image: UIImage) {
        view.layoutIfNeeded()
        singleImage.image = image

        let imageViewSize = image.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        let minScale = max(widthScale, heightScale)

        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
        scrollView.contentSize = imageViewSize
        centerScrollViewContents()
    }

    private func centerScrollViewContents() {
        let imageViewSize = singleImage.frame.size
        let scrollViewSize = scrollView.bounds.size
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }

}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return singleImage
    }
}
