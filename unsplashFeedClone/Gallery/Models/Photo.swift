//
//  Photo.swift
//  unsplashFeedClone
//
//  Created by Nguyen Xuan Tho on 17/11/2021.
//

import Foundation

struct Photo: Codable {
    var id: String
    var user: User
    var likes: Int
    var urls: Link
}
