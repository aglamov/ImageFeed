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
    private (set) var ava: Ava?
    private (set) var profileImageURL: ProfileImageURL?
    private let urlSession = URLSession.shared
    private var token = OAuth2TokenStorage.shared.token
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
    
        task?.cancel()
        guard let request = profileUserRequest(token: token!, username: username) else { return }
        task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
           // DispatchQueue.main.async {
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
                        let UserResult = try decoder.decode(UserResult.self, from: data)
                        guard let self = self else { return }
                        let avaURL = UserResult.profile_image.small
                     //   self.profileImageURL?.small = avaURL
                      //  self.avatarURL = avaURL
                       // completion(.success((self.avatarURL!)))
                       // completion(.success((self.profileImageURL?.small!)!))
                       // self.profile = Profile(username: username, name: name, loginName: loginName, bio: bio)
                        self.ava = Ava(avaUrl: avaURL!)
                        completion(.success(self.ava!.avaUrl))
                        NotificationCenter.default                                     // 1
                            .post(                                                     // 2
                                name: ProfileImageService.DidChangeNotification,       // 3
                                object: self,                                          // 4
                                userInfo: ["URL": self.ava!.avaUrl])                    // 5
                     //   completion(.success(avaURL))
                       // return
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(NetworkError.noData))
                }
            }
      //  }
        task!.resume()
    }
}

private func profileUserRequest (token: String, username: String) -> URLRequest? {
    let url = URL(string: "\(DefaultBaseURL)users/\(username)")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    return request
}
