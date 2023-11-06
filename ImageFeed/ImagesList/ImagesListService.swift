import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    private(set) var photos: [Photo] = []
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private var lastLoadedPage: Int?
    private var task: URLSessionDataTask?
    private let perPage = "10"
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" 
        return formatter
    }()
    var nextPage: Int = 1

    func fetchPhotosNextPage(completion: @escaping ([Photo]?, Error?) -> Void) {
        assert(Thread.isMainThread)
        if task != nil { return }

        if let lastPage = lastLoadedPage {
            nextPage = lastPage + 1
        } else {
            nextPage = 1
        }

        guard let request = listImagesRequest(token: OAuth2TokenStorage.shared.token ?? "", page: String(nextPage), perPage: perPage) else { return }

        task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(nil, NetworkError.invalidStatusCode)
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, NetworkError.noData)
                }
                return
            }

            let decoder = JSONDecoder()
            do {
                let photoResults = try decoder.decode([PhotoResult].self, from: data)
                let newPhotos = photoResults.map { photoResult -> Photo in
                    let id = photoResult.id
                    let size = CGSize(width: photoResult.width, height: photoResult.height)
                    let createdAt = self?.dateFormatter.date(from: photoResult.createdAt ?? "")
                    let welcomeDescription = photoResult.description ?? ""
                    let isLiked = photoResult.likedByUser
                    let thumbImageURL = photoResult.urls.thumb
                    let largeImageURL = photoResult.urls.full

                    return Photo(id: id, size: size, createdAt: createdAt, welcomeDescription: welcomeDescription, thumbImageURL: thumbImageURL, largeImageURL: largeImageURL, isLiked: isLiked)
                }

                self?.photos.append(contentsOf: newPhotos)
                self?.lastLoadedPage =  self?.nextPage

                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self, userInfo: ["Images": self?.photos as Any])
                    completion(newPhotos, nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }

        task?.resume()
    }
}

private func listImagesRequest(token: String, page: String, perPage: String) -> URLRequest? {
    guard let url = URL(string: "\(Constants.defaultBaseURL)photos?page=\(page)&per_page=\(perPage)") else { return nil }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"

    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    return request
}
