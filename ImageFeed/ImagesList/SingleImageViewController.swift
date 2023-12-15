//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Рамиль Аглямов on 21.05.2023.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    private var singleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var imageURL: URL! {
        didSet {
            guard isViewLoaded else { return }
            setImage()
        }
    }
    
    private var scrollView: UIScrollView!
    
    
    @objc private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapShareButton(_ sender: Any) {
        let share = UIActivityViewController(
            activityItems: [singleImage as Any],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    private func addBackButton () -> UIButton {
        lazy var backButton = UIButton.systemButton(
            with: UIImage(imageLiteralResourceName: "Backward"),
            target: self,
            action: #selector(Self.didTapBackButton)
            
        )
        backButton.tintColor = UIColor(named: "ypBlue")
        backButton.setTitle("Назад", for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        return backButton
    }
    
    private func addShareButton() -> UIButton {
        let shareButton = UIButton(type: .system)
        shareButton.setBackgroundImage(UIImage(imageLiteralResourceName: "ShareBottom"), for: .normal)
        shareButton.tintColor = UIColor.white
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.addTarget(self, action: #selector(self.didTapShareButton), for: .touchUpInside)
        return shareButton
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.frame = view.bounds
        scrollView.contentSize = singleImage.frame.size
        view.addSubview(scrollView)
        
        view.addSubview(singleImage)
        singleImage.tintColor = .gray
        singleImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        singleImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        singleImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        singleImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        let shareButton = addShareButton()
        view.addSubview(shareButton)
        shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -51).isActive = true
           
        let backButton = addBackButton()
        view.addSubview(backButton)
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9).isActive = true
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9).isActive = true
        backButton.accessibilityIdentifier = "BackButton"
     
        setImage()
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
        singleImage.image = image
            singleImage.sizeToFit()
            scrollView.contentSize = singleImage.bounds.size
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 1.25
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
