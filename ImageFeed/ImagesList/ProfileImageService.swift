//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Рамиль Аглямов on 25.10.2023.
//

import Foundation


final class ProfileImageService {
    static let shared = ProfileImageService()
    private (set) var avatarURL: String?
    private var task: URLSessionDataTask?
    private (set) var profile: Profile?
    private (set) var profileImageURL: ProfileImageURL?
    private let urlSession = URLSession.shared
    private var token = OAuth2TokenStorage.shared.token
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        task?.cancel()
        
        guard let request = profileUserRequest(token: OAuth2TokenStorage.shared.token ?? "", username: username) else { return }
        task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in

                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200..<300).contains(httpResponse.statusCode) else {
                    completion(.failure(NetworkError.invalidStatusCode))
                    return
                }
                
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let userResult = try decoder.decode(UserResult.self, from: data)
                        guard let self = self else { return }
                        let avaURL = userResult.profileImage.small
                        self.profileImageURL = ProfileImageURL(small: avaURL ?? "")
                        
                        NotificationCenter.default
                            .post(
                                name: ProfileImageService.didChangeNotification,
                                object: self,
                                
                                userInfo: ["URL": self.profileImageURL?.small as Any])
                        completion(.success(self.profileImageURL?.small ?? ""))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(NetworkError.noData))
                }
            }
        task?.resume()
    }
}

private func profileUserRequest (token: String, username: String) -> URLRequest? {
    guard let url = URL(string: "\(Constants.defaultBaseURL)users/\(username)") else { return nil}
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    return request
}
