//
//  Connection.swift
//  unsplashFeedClone
//
//  Created by Nguyen Xuan Tho on 16/11/2021.
//

import Foundation

protocol Connection {
    typealias Completion = (Data?, APIError?) -> Void
    
    var baseURL: String { get set }
    func makeRequest(_ request: Request, completion: @escaping Connection.Completion) -> URLSessionDataTask
}

class APIConnection: Connection {
    
    var baseURL: String
    
    private var session: URLSession {
        return URLSession.shared
    }
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    @discardableResult
    func makeRequest(_ request: Request, completion: @escaping Connection.Completion) -> URLSessionDataTask {
        let urlRequest = request.asURLRequest(baseURL)
        debugPrint("Current request: \(urlRequest.url!.absoluteString)")
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                self.handleError(error, completion)
            } else if let response = response as? HTTPURLResponse {
                self.handleResponse(response, data, completion)
            } else {
                completion(nil, APIError.unknown)
            }
        }
        task.resume()
        
        return task
    }
    
    private func handleResponse(_ response: HTTPURLResponse, _ data: Data?, _ completion: Connection.Completion) {
        switch response.statusCode {
        case 200...299:
            if let data = data {
                completion(data, nil)
            } else {
                completion(nil, APIError.noData)
            }
        case 400...499:
            completion(nil, APIError.clientError)
        case 500...599:
            completion(nil, APIError.serverError)
        default:
            completion(nil, APIError.unknown)
        }
    }
    
    private func handleError(_ error: Error, _ completion: Connection.Completion) {
        let nsError = error as NSError
        switch nsError.code {
        case NSURLErrorNotConnectedToInternet:
            completion(nil, APIError.noNetwork)
        case NSURLErrorTimedOut:
            completion(nil, APIError.timeout)
        default:
            completion(nil, APIError.unknown)
        }
    }
}
