//
//  Error.swift
//  unsplashFeedClone
//
//  Created by Nguyen Xuan Tho on 16/11/2021.
//

import Foundation

enum APIError: Error {
    case unknown
    case noNetwork
    case timeout
    case parseFailure
    case clientError
    case serverError
    case noData
}
