import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    private(set) var photos: [Photo] = []
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private var lastLoadedPage: Int?
    private var task: URLSessionDataTask?
    private let perPage = "10"
    private let dateFormatter = ISO8601DateFormatter()
    
    var nextPage: Int = 1
    
    func fetchPhotosNextPage(completion: @escaping ([Photo]?, Error?) -> Void) {
        assert(Thread.isMainThread)
        if task != nil { return }
        if let lastPage = lastLoadedPage {
            nextPage = lastPage + 1
        } else {
            nextPage = 1
        }
        guard let token = OAuth2TokenStorage.shared.token else { completion(nil, Error?.self as? Error); return  }
        
        guard let request = listImagesRequest(token: token, page: String(nextPage), perPage: perPage) else { return }
        
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
                
                NotificationCenter.default
                    .post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: ["Photos": self?.photos as Any])
                completion(newPhotos, nil)
                
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        
        task?.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let index = self.photos.firstIndex(where: { $0.id == photoId }) else {
            completion(.failure(Error.self as! Error))
            return
        }
        
        let photo = self.photos[index]
        let newPhoto = Photo(
            id: photo.id,
            size: photo.size,
            createdAt: photo.createdAt,
            welcomeDescription: photo.welcomeDescription,
            thumbImageURL: photo.thumbImageURL,
            largeImageURL: photo.largeImageURL,
            isLiked: !isLike
        )
        self.photos[index] = newPhoto
    
        guard let request = likeImagesRequest(token: OAuth2TokenStorage.shared.token ?? "", photoID: photoId, likeDislike: isLike) else {
            completion (.failure(NetworkError.noData))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.invalidStatusCode))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.noData))
                }
                return
            }
            
            if let photoResult = try? JSONDecoder().decode(PhotoResult.self, from: data) {
                let updatedPhoto = Photo(
                    id: photoResult.id,
                    size: CGSize(width: photoResult.width, height: photoResult.height),
                    createdAt: self?.dateFormatter.date(from: photoResult.createdAt ?? ""),
                    welcomeDescription: photoResult.description ?? "",
                    thumbImageURL: photoResult.urls.thumb,
                    largeImageURL: photoResult.urls.full,
                    isLiked: photoResult.likedByUser
                )
                self?.photos[index] = updatedPhoto
                self?.lastLoadedPage = self?.nextPage
                
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self,
                    userInfo: ["Photos": self?.photos as Any]
                )
                DispatchQueue.main.async {
                    completion(.success(()))
                }
                
            } else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.dataDecodingError))
                }
            }
        }
        completion(.success(()))
        task.resume()
    }
    
    func clean() {
        photos = []
        lastLoadedPage = nil
        task?.cancel()
        task = nil
    }
    
}

private func listImagesRequest(token: String, page: String, perPage: String) -> URLRequest? {
    guard let url = URL(string: "\(Constants.defaultBaseURL)photos?page=\(page)&per_page=\(perPage)") else { return nil }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    return request
}

private func likeImagesRequest(token: String, photoID: String, likeDislike: Bool) -> URLRequest? {
    guard let baseURL = URL(string: "\("Constants.defaultBaseURL")") else { return nil }
    let endpoint: String
    let httpMethod: String
    
    if likeDislike {
        endpoint = "/photos/\(photoID)/like"
        httpMethod = "POST"
    } else {
        endpoint = "/photos/\(photoID)/like"
        httpMethod = "DELETE"
    }
    
    let url = baseURL.appendingPathComponent(endpoint)
    var request = URLRequest(url: url)
    
    request.httpMethod = httpMethod
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    return request
}
