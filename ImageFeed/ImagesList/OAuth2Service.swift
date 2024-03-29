////
////  OAuth2Service.swift
////  ImageFeed
////
////  Created by Рамиль Аглямов on 10.07.2023.
////
//
import UIKit

final class OAuth2Service {
    static let shared = OAuth2Service()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profile: Profile?
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        } }
    
    func fetchOAuthToken(
        _ code: String,
        completion: @escaping (Result<String, Error>) -> Void ){
            assert(Thread.isMainThread)
            if lastCode == code { return }
            task?.cancel()
            lastCode = code
            
            let request = authTokenRequest(code: code)
            let task = object(for: request) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    let authToken = body.accessToken
                    self.authToken = authToken
                    self.fetchProfile(token: authToken)
                    self.task = nil
                    completion(.success(authToken))
                case .failure(let error):
                    completion(.failure(error))
                    self.lastCode = nil
                }
            }
            self.task = task
            task.resume()
        }
    
    private func fetchProfile(token:String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.profile = profile
                UIBlockingProgressHUD.dismiss()
                self.fetchProfileImage(name: profile.username)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                break
            }
        }
    }
    
    private func fetchProfileImage(name: String) {
        profileImageService.fetchProfileImageURL(username: name) { result in
            UIBlockingProgressHUD.dismiss()
        }
    }
}

extension OAuth2Service {
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                Result { try decoder.decode(OAuthTokenResponseBody.self, from: data) }
            }
            completion(response)
        }
    }
    private func authTokenRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!
        ) }
    private struct OAuthTokenResponseBody: Decodable {
        let accessToken: String
        let tokenType: String
        let scope: String
        let createdAt: Int
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
            case scope
            case createdAt = "created_at"
        }
    } }

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = Constants.defaultBaseURL
          
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        return request
    } }

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case noData
    case invalidStatusCode
    case dataDecodingError
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletion(.success(data))
                } else {
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        })
        task.resume()
        return task
    } }
