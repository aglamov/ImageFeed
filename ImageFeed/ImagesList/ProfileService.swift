//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Рамиль Аглямов on 22.10.2023.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private (set) var profile: Profile?
    private var task: URLSessionDataTask?
    
    private let urlSession = URLSession.shared
    private var token = OAuth2TokenStorage.shared.token
    static let didChangeNotification = Notification.Name(rawValue: "ProfileProviderDidChange")
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let request = profileRequest(token: token) else { return }
        task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
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
                        let profileResult = try decoder.decode(ProfileResult.self, from: data)
                        guard let self = self else { return }
                        let username = profileResult.username
                        let loginName = "@" + profileResult.username
                        let name = "\(profileResult.firstName ?? "") \(profileResult.lastName ?? "")"
                        let bio = profileResult.bio ?? ""
                        self.profile = Profile(username: username, name: name, loginName: loginName, bio: bio)
                        
                        NotificationCenter.default
                            .post(
                                name: ProfileService.didChangeNotification,
                                object: self,
                                userInfo: ["user": self.profile?.name as Any, "loginName": self.profile?.loginName as Any, "bio": self.profile?.bio as Any])
                        
                        ProfileImageService.shared.fetchProfileImageURL(username: username) { _ in}
                       
                        completion(.success(self.profile!))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(NetworkError.noData))
                }
            }
        }
        task!.resume()
    }
}

private func profileRequest (token: String) -> URLRequest? {
    let url = URL(string: "\(Constants.defaultBaseURL)me")!
    var request = URLRequest(url: url)  
    request.httpMethod = "GET"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    return request
}
