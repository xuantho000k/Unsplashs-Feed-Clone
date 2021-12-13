//
//  GalleryService.swift
//  unsplashFeedClone
//
//  Created by Nguyen Xuan Tho on 16/11/2021.
//

import Foundation

struct PhotoRouter {
    static func getPath(sub: String) -> String {
        
        return "/photos" + sub
    }
    struct List: Readable {
        typealias Completion = ([Photo]?, APIError?) -> Void
        var path = getPath(sub: "")
    }
    struct Like: Creatable {
        typealias Completion = (Bool, APIError?) -> Void
        var path = getPath(sub: "")
    }
}

class PhotoService {
    
    var api: APIConnection
    
    init(_ api: APIConnection) {
        self.api = api
    }
    
    func getListPhotos(page: Int, completion: @escaping PhotoRouter.List.Completion) {
        let authorization = ["Authorization": "Client-ID \(Constants.accessKey)"]
        
        api.makeRequest(PhotoRouter.List().get(["page": String(page)], headers: authorization)) { data, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            do {
                let photos = try JSONDecoder().decode([Photo].self, from: data)
                completion(photos, nil)
            } catch {
                completion(nil, APIError.parseFailure)
            }
            
        }
    }
    
    func likePhoto(_ id: String, completion: @escaping PhotoRouter.Like.Completion) {
        let authorization = ["Authorization": "Bearer "]
        
        api.makeRequest(PhotoRouter.Like().create("\(id)/like", headers: authorization)) { data, error in
            guard let _ = data else {
                completion(false, error)
                return
            }
            completion(true, nil)
        }
    }
}
