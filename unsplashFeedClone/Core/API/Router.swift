//
//  Router.swift
//  unsplashFeedClone
//
//  Created by Nguyen Xuan Tho on 16/11/2021.
//

import Foundation

typealias Parameters = [String: String]

typealias HTTPHeaders = [String: String]

protocol Router {
    var path: String {get set}
}

extension Router {
    func getRoute(_ param: String) -> String {
        var route = "\(path)"
        if (!param.isEmpty) {
            route += "/\(param)"
        }

        return route
    }
}

protocol Readable: Router {}

extension Readable {
    func get() -> APIRequest {
        return APIRequest(method: .get, route: getRoute(""))
    }
    func get(_ param: String) -> Request {
        return APIRequest(method: .get, route: getRoute(param))
    }
    func get(_ param: Parameters) -> Request {
        return APIRequest(method: .get, route: getRoute(""), parameters: param)
    }
    func get(_ param: Parameters, headers: HTTPHeaders) -> Request {
        return APIRequest(method: .get, route: getRoute(""), parameters: param, headers: headers)
    }
}

protocol Creatable: Router {}

extension Creatable {
    func create(_ param: Parameters) -> Request {
        return APIRequest(method: .post, route: getRoute(""), parameters: param)
    }
    func create(_ param: String, headers: HTTPHeaders) -> Request {
        return APIRequest(method: .post, route: getRoute(param), headers: headers)
    }
}
