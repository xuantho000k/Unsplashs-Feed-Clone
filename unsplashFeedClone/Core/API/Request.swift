//
//  Request.swift
//  unsplashFeedClone
//
//  Created by Nguyen Xuan Tho on 16/11/2021.
//

import Foundation

protocol Request {
    var method: HTTPMethod {get set}
    var route: String {get set}
    func asURLRequest(_ baseURL: String) -> URLRequest
}

struct APIRequest: Request {
    
    var method: HTTPMethod
    var route: String
    var parameters: Parameters = [:]
    var headers: HTTPHeaders = [:]

    func asURLRequest(_ baseURL: String) -> URLRequest {
        guard let url = makeURL(baseURL) else {
            assert(false, "Can't crate URL from string")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        for header in headers {
            urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
        }
        if method == .post {
            urlRequest.httpBody = makeBody(parameters)
        }

        return urlRequest
    }
    
    private func makeURL(_ url: String) -> URL? {
        var temp = URLComponents(string: url + route)
        if method == .get {
            temp?.queryItems = parameters.map({ it -> URLQueryItem in
                return URLQueryItem(name: it.key, value: it.value)
            })
        }
        return temp?.url
    }
    
    private func makeBody(_ param: Parameters) -> Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            return jsonData
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
}
